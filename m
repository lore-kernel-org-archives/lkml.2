Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab1FVKVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:21:49 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14915 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab1FVKVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:21:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6384"; a="99293794"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>
Cc: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1308731945-7601-1-git-send-email-tlinder@codeaurora.org> <1308731945-7601-2-git-send-email-tlinder@codeaurora.org> <20110622095205.GA24674@linutronix.de>
In-Reply-To: <20110622095205.GA24674@linutronix.de>
Subject: RE: [RFC/PATCH v2 1/2] usb:dummy_hcd: connect/disconnect test support
Date: Wed, 22 Jun 2011 13:21:43 +0300
Message-ID: <021101cc30c6$30dd7760$92986620$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwwwhYhuV+a8DTYSbWOoT5QPPTCwQAA25lg
Content-Language: he
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

> * Tatyana Brokhman | 2011-06-22 11:39:00 [+0300]:
> 
> >This implementation adds a new proprietary device control requests (to
> be
> >handled by the dummy_hcd) that initiates a connect/disconnect
> sequence.
> >The bRequest value of the new control request is 0x52.
> >It is used by the user-space Unit testing application.
> >
> >Signed-off-by: Tatyana Linder <tlinder@codeaurora.org>
> 
> As far as I understand this should be used to test real Hardware. Mind
> moving this to composite_setup() so it can be re-used by other ucd as
> well? usb_gadget_*nect() should do the pullup() trick.
> 

Felipe also suggested that on the last version of this patch. Here is a
quote of his email on the subject:

"actually, this is quite useful. Specially for the controllers which _can_
do soft-connect by toggling data pullups. I would rather have these sort of
thing maybe in composite.c, so that we can build tests with all gadget
drivers/controllers, not only dummy_hcd.

That said, I think now it's not the time to fiddle too much with these
details right now. So best to keep this in dummy_hcd until we know the test
tools are actually good."

So, right now I'll leave it in dummy_hcd if it's ok with you.


Thanks,
Tanya Brokhman
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.




