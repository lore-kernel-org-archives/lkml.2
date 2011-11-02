Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282Ab1KBSIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:08:41 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41137 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab1KBSIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:08:39 -0400
Message-ID: <1320257237.12249.8.camel@js-netbook>
Subject: Re: [RFC][PATCH] clocksource: Avoid selecting mult values that
 might overflow when adjusted
From: John Stultz <john.stultz@linaro.org>
To: Chen Jie <chenj@lemote.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 02 Nov 2011 14:07:17 -0400
In-Reply-To: <CAGXxSxUqzu8gBHU3GeCj1zmYdQdbC68dqaE1PeiBaOssPobo-g@mail.gmail.com>
References: <1320097228-3612-1-git-send-email-john.stultz@linaro.org>
	 <CAGXxSxUqzu8gBHU3GeCj1zmYdQdbC68dqaE1PeiBaOssPobo-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11110218-7282-0000-0000-0000032D0684
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-02 at 10:27 +0800, Chen Jie wrote:
> Hi,
> We've backported the patch to our kernel, and redo the test[1] that
> formerly caused system stall.
> After 12-hours, no system stall observed.

Thanks for testing! I've revised the patch a touch, and will get it
queued for more testing & inclusion.

thanks
-john


