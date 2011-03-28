Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab1C1WFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:05:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855Ab1C1WFm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:05:42 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103282227510.2774@localhost6.localdomain6>
References: <alpine.LFD.2.00.1103282048370.2774@localhost6.localdomain6>
 <AANLkTintrwhwbyZGxX1Eecg9ZXo+NgRzTwyyMyzt1JGR@mail.gmail.com>
 <alpine.LFD.2.00.1103282210590.2774@localhost6.localdomain6> <alpine.LFD.2.00.1103282227510.2774@localhost6.localdomain6>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 Mar 2011 15:05:21 -0700
Message-ID: <AANLkTin7Uc=LzZdD4Waj8GF24Nzi2ccUL+RLtk+fBc=g@mail.gmail.com>
Subject: Re: [GIT pull] irq cleanups for .39
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Fainelli <florian@openwrt.org>, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 1:29 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 28 Mar 2011, Thomas Gleixner wrote:
>> 2) msg ids are unique and can ge grepped for. also there are archives
>>    which allow searching for them.
>>
>>    http://marc.info?i=alpine.LFD.2.00.1103252150180.31464@localhost6.localdomain6
>>
>>    http://mid.gmane.org/alpine.LFD.2.00.1103252150180.31464@localhost6.localdomain6
>
> So perhaps we should add one of those into the LKML-Reference and let
> the commit bot extract the thread reference from there.

Yes. That would make it something usable to normal users.

                     Linus
