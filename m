Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab2GXG4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 02:56:41 -0400
Received: from void.printf.net ([89.145.121.20]:59588 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab2GXG4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 02:56:39 -0400
From: Chris Ball <cjb@laptop.org>
To: "Yaniv Gardi" <ygardi@codeaurora.org>
Cc: <linux-mmc@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>, <merez@codeaurora.org>,
        Girish K S <girish.shivananjappa@linaro.org>,
        "S\, Venkatraman" <svenkatr@ti.com>,
        "Dong\, Chuanxiao" <chuanxiao.dong@intel.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH RESEND v7 2/2] mmc: card: Adding support for sanitize in eMMC 4.5
References: <1340872367-16206-1-git-send-email-ygardi@codeaurora.org>
	<1340872367-16206-3-git-send-email-ygardi@codeaurora.org>
	<87629k9rkc.fsf@octavius.laptop.org>
	<f5830acb2ddca29357a0125cd8f3d577.squirrel@www.codeaurora.org>
	<000001cd6967$2ce2a010$86a7e030$@codeaurora.org>
Date: Tue, 24 Jul 2012 02:56:17 -0400
In-Reply-To: <000001cd6967$2ce2a010$86a7e030$@codeaurora.org> (Yaniv Gardi's
	message of "Tue, 24 Jul 2012 09:40:08 +0300")
Message-ID: <87obn5y7e6.fsf_-_@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yaniv,

On Tue, Jul 24 2012, Yaniv Gardi wrote:
> Are there any additional open issues to discuss regarding the sanitize
> capability ?
> If not, we would like to see this patch pushed into mmc-next.

I think you've responded to all of the open issues, thanks -- I'm adding
everyone who made a review comment to the CC list for this mail, so that
they can check whether v7 addresses their concerns, and consider asking
more questions or providing a Reviewed-by.

How are you doing with getting the block layer patches merged?  I'd like
to get both layers into linux-next around the same time, if we can.

I wonder if there's any way to test whether sanitize has had an effect.
It would be good to know whether it actually does anything on a specific
eMMC, although I'm sure it's difficult to tell.

Thanks!

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
