Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2F1Rhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:37:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57310 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab2F1Rhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:37:38 -0400
Message-ID: <4FEC965F.4060104@wwwdotorg.org>
Date: Thu, 28 Jun 2012 11:37:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux@arm.linux.org.uk, ccross@android.com, olof@lixom.net
Subject: Re: [PATCH 2/6] ARM: tegra20: Separate out clk ops and clk data
References: <1340879846-12900-1-git-send-email-pgaikwad@nvidia.com> <1340879846-12900-3-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1340879846-12900-3-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 04:37 AM, Prashant Gaikwad wrote:
> Move clock initialization data to separate file. This is
> required for migrating to generic clock framework if static
> initialization is used.
> 
> TODO: Add clock suspend/resume support

Is the suspend/resume code something that was present in the existing
Tegra clock code? If not, I'd be tempted to just drop that TODO line
from the patch description when applying this.
