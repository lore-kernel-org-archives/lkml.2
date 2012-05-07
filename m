Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab2EGQSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:18:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50956 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab2EGQSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:18:49 -0400
Message-ID: <4FA7F5E5.4070609@wwwdotorg.org>
Date: Mon, 07 May 2012 10:18:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 1/2] i2c: tegra: make all resource allocation through
 devm_*
References: <1336373179-12739-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1336373179-12739-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2012 12:46 AM, Laxman Dewangan wrote:
> Use the devm_* for the memory region allocation, interrupt request,
> clock handler request.
> By doing this, it does not require to explicitly free it and hence
> saving some code.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Note thought that devm_clk_get() appears to have been introduced very
recently in linux-next, so in order to merge this patch one of the
following has to happen:

a) This patch goes through the tree that merged the addition of
devm_clk_get() (which I think is Russell King's ARM tree)

b) Whichever tree takes this patch must first merge a branch that
contains that patch that adds devm_clk_get().
