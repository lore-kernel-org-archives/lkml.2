Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab2GYJju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 05:39:50 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44252 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2GYJjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 05:39:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6782"; a="211907566"
From: "Yaniv Gardi" <ygardi@codeaurora.org>
To: "'Chris Ball'" <cjb@laptop.org>, <axboe@kernel.dk>
Cc: <linux-mmc@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>, <merez@codeaurora.org>,
        "'Girish K S'" <girish.shivananjappa@linaro.org>,
        "'S, Venkatraman'" <svenkatr@ti.com>,
        "'Dong, Chuanxiao'" <chuanxiao.dong@intel.com>,
        "'Stephen Boyd'" <sboyd@codeaurora.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Kyungmin Park'" <kmpark@infradead.org>, <merez@codeaurora.org>
References: <1340872367-16206-1-git-send-email-ygardi@codeaurora.org>	<1340872367-16206-3-git-send-email-ygardi@codeaurora.org>	<87629k9rkc.fsf@octavius.laptop.org>	<f5830acb2ddca29357a0125cd8f3d577.squirrel@www.codeaurora.org>	<000001cd6967$2ce2a010$86a7e030$@codeaurora.org> <87obn5y7e6.fsf_-_@octavius.laptop.org>
In-Reply-To: <87obn5y7e6.fsf_-_@octavius.laptop.org>
Subject: RE: [PATCH RESEND v7 2/2] mmc: card: Adding support for sanitize in eMMC 4.5
Date: Wed, 25 Jul 2012 12:39:43 +0300
Message-ID: <000401cd6a49$6e74aef0$4b5e0cd0$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHbbDwGtVR7542ubm/TS3EGnuY2sQDa9+k6AQmswqUCFNjQbQFZOIVVApupRT+W3kX98A==
Content-language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Jens Axboe

Hi Jens,
Can you please review the v8 patch and refer to it? As seen below,
everything is all set to push the change in the mmc layer,
But it's better to push the feature to both modules

Hi Chris,
I just uploaded a v8, which has small fix in the block layer. It has no
changes at all, in the mmc layer.
Hope we soon have a reply from Jens regarding when the sanitize patch can be
pushed in to linux-next in the block layer.


Thanks,
Yaniv

= > -----Original Message-----
= > From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-
= > owner@vger.kernel.org] On Behalf Of Chris Ball
= > Sent: Tuesday, July 24, 2012 9:56 AM
= > To: Yaniv Gardi
= > Cc: linux-mmc@vger.kernel.org; linux-arm-msm@vger.kernel.org; 'open
= > list'; merez@codeaurora.org; Girish K S; S, Venkatraman; Dong,
Chuanxiao;
= > Stephen Boyd; Jaehoon Chung; Kyungmin Park
= > Subject: Re: [PATCH RESEND v7 2/2] mmc: card: Adding support for
= > sanitize in eMMC 4.5
= > 
= > Hi Yaniv,
= > 
= > On Tue, Jul 24 2012, Yaniv Gardi wrote:
= > > Are there any additional open issues to discuss regarding the sanitize
= > > capability ?
= > > If not, we would like to see this patch pushed into mmc-next.
= > 
= > I think you've responded to all of the open issues, thanks -- I'm adding
= > everyone who made a review comment to the CC list for this mail, so that
= > they can check whether v7 addresses their concerns, and consider asking
= > more questions or providing a Reviewed-by.
= > 
= > How are you doing with getting the block layer patches merged?  I'd like
to
= > get both layers into linux-next around the same time, if we can.
= > 
= > I wonder if there's any way to test whether sanitize has had an effect.
= > It would be good to know whether it actually does anything on a specific
= > eMMC, although I'm sure it's difficult to tell.
= > 
= > Thanks!
= > 
= > - Chris.
= > --
= > Chris Ball   <cjb@laptop.org>   <http://printf.net/>
= > One Laptop Per Child
= > --
= > To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
the
= > body of a message to majordomo@vger.kernel.org More majordomo info
= > at  http://vger.kernel.org/majordomo-info.html

