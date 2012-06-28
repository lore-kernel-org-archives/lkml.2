Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab2F1Rj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:39:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49910 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2F1RjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:39:25 -0400
Message-ID: <4FEC96C9.5040906@wwwdotorg.org>
Date: Thu, 28 Jun 2012 11:39:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: mturquette@ti.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux@arm.linux.org.uk, ccross@android.com, olof@lixom.net
Subject: Re: [PATCH 0/6] Port Tegra to generic clk framework
References: <1340879846-12900-1-git-send-email-pgaikwad@nvidia.com>
In-Reply-To: <1340879846-12900-1-git-send-email-pgaikwad@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 04:37 AM, Prashant Gaikwad wrote:
> This patch set ports Tegra clock code to generic clock framework.

I've looked at this a bit off-list before, and any issues I had with it
have been resolved already. I'll likely apply it to Tegra's for-next in
fairly short order unless anyone jumps in with objections to my doing
so. This will give it more wide-spread testing. We can always pull it
out again if any significant issues are found.
