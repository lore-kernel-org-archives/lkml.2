Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2HQT1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 15:27:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46538 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2HQT1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 15:27:08 -0400
Message-ID: <502E9B09.3080800@wwwdotorg.org>
Date: Fri, 17 Aug 2012 13:27:05 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: swarren@nvidia.com, olof@lixom.net, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] ARM: dt: tegra: harmony: add regulators
References: <1345186799-18229-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1345186799-18229-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2012 12:59 AM, Laxman Dewangan wrote:
> Harmony uses a TPS6586x regulator. Instantiate this, and hook up a
> couple of fixed GPIO-controlled regulators too.
> 
> Based on Ventana regulator patch by Stephen Warren <swarren@nvidia.com>
> and converted to Harmony.

Thanks, applied to Tegra's for-3.7/dt branch.

