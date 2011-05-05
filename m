Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1EEUng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 16:43:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34752 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab1EEUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 16:43:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ppggpavd39o4YpAi5IwF9mcTA96YNVIa49w1BX3hgkRR+mHQXWQu4yRX+scxU19Nzs
         07LAh7h+A+CF0GOYs3Il4dt48XiNSJiGSjzPYcE2JsCRvufeuY07N5EdTmxYH99f6QvT
         HxAQG0jvlWxC6Rzp1OBTBi4qz6b45lYYUFJbI=
Subject: Re: [PATCH] time: Add locking to xtime access in get_seconds()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1304628050.20980.34.camel@work-vm>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
	 <m2oc3jxgtt.fsf@firstfloor.org> <1304564090.2943.36.camel@work-vm>
	 <20110505175713.GG2925@one.firstfloor.org>
	 <1304626621.20980.19.camel@work-vm>
	 <1304627098.3131.1.camel@edumazet-laptop>
	 <1304628050.20980.34.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 22:43:31 +0200
Message-ID: <1304628211.3131.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 05 mai 2011 à 13:40 -0700, john stultz a écrit :

> Currently, yes. 
> But as I mentioned in an earlier mail, the problem was with
> 2.6.32-stable.

Oops sorry, I forgot this :(



