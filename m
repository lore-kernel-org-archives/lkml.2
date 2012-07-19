Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab2GSGqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 02:46:19 -0400
Received: from void.printf.net ([89.145.121.20]:54385 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab2GSGqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 02:46:17 -0400
From: Chris Ball <cjb@laptop.org>
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, merez@codeaurora.org,
        linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH RESEND v7 2/2] mmc: card: Adding support for sanitize in eMMC 4.5
References: <1340872367-16206-1-git-send-email-ygardi@codeaurora.org>
	<1340872367-16206-3-git-send-email-ygardi@codeaurora.org>
Date: Thu, 19 Jul 2012 02:46:11 -0400
In-Reply-To: <1340872367-16206-3-git-send-email-ygardi@codeaurora.org> (Yaniv
	Gardi's message of "Thu, 28 Jun 2012 11:32:46 +0300")
Message-ID: <87629k9rkc.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yaniv,

On Thu, Jun 28 2012, Yaniv Gardi wrote:
> This feature delete the unmap memory region of the eMMC card,
> by writing to a specific register in the EXT_CSD
> unmap region is the memory region that were previously deleted
> (by erase, trim or discard operation)
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

Did you reply to Chuanxiao's review comments yet?  He said:

"So to implement your scenario, how about only add
mmc_blk_issue_sanitize_rq() for REQ_SANITIZE but not touch
mmc_blk_issue_secdiscard_rq()? With your changes in
mmc_blk_issue_secdiscard_rq(), eMMC4.5 device will be failed to operate
secure trim/erase for REQ_SECURE request."

at: http://thread.gmane.org/gmane.linux.kernel.mmc/14822/focus=14880

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
