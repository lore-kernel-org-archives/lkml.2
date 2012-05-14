Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab2ENSdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:33:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55585 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab2ENSdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:33:05 -0400
Message-ID: <4FB14FDE.2080409@wwwdotorg.org>
Date: Mon, 14 May 2012 12:33:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 1/1] memory: tegra{20,30}-mc: Use dev_err_ratelimited()
References: <1336981680-15297-2-git-send-email-hdoyu@nvidia.com> <1336990031-15567-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1336990031-15567-1-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 04:07 AM, Hiroshi DOYU wrote:
> Introduce a new dev_*_ratelimited() instead of pr_*_ratelimited() for
> better info to print.
> 
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

But note that this relies on the following patch or a variant of it:

http://patchwork.ozlabs.org/patch/158899/

which isn't anywhere yet.

(A variant of that patch was patch 1/2 the first time this patch was
posted, but v2 of this patch was posted separately without mentioning
the dependency)
