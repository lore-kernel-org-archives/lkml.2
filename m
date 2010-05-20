Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab0ETJZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:25:45 -0400
Received: from mail-qy0-f171.google.com ([209.85.221.171]:53079 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab0ETJZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:25:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dahlCIHiSSxY/rLSL5qV4EgNPxQV+4pHVLe5nMMqDSwdyguHgVJBxY2CE8ydX6O56s
         /l/Y8cp1on7Gtto/DZadeYN9aAgxkgnjZf1qCQsQAzpg8Buo6vscFcMvN28QoQVUB+ec
         Tflk7AWnulp8qD90ZP59OvZeQY04lhcD9Qc+4=
MIME-Version: 1.0
In-Reply-To: <201005201233.56877@zigzag.lvk.cs.msu.su>
References: <AANLkTimxLHngWamPvWt-htGoZ7Nub72rvJAnmGtw4Eqw@mail.gmail.com>
	 <AANLkTinClrTDoXH4NPP2-SgSYH24ZTnqsop88aocdg4R@mail.gmail.com>
	 <alpine.LFD.2.00.1005182143100.3368@localhost.localdomain>
	 <201005201233.56877@zigzag.lvk.cs.msu.su>
Date: Thu, 20 May 2010 14:55:42 +0530
Message-ID: <AANLkTilEbFndi-rPczi6OBxeU8p87gOz4yfveEsyHqcE@mail.gmail.com>
Subject: Re: PREEMPT_RT (2.6.33-rt17) disabled printk-to-console after 
	console_init
From: Sujit K M <sjt.kar@gmail.com>
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://www.vanemery.com/Linux/Serial/serial-console.html

Could this be of help.

On Thu, May 20, 2010 at 2:03 PM, Nikita V. Youshchenko <yoush@cs.msu.su> wrote:
>> > I could not get dmesg output to console/serial and
>> > klogd(/var/log/messages) anymore with 2.6.33-rt17 _after_ the kernel
>> > boot is done(on non-RT kernel it works fine). I made below changes it
>> > starts to work again, however I'm unsure how safe the change is.
>> > Please advise.
>>
>> Well, obviously it's unsafe if you remove safety checks. And if you
>> care to look at the changelog of kernel/printk.c you'll find out why.
>
> Hmm... did a quick look and could not find anything related there.
> Could you please give a pointer?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
-- Sujit K M

blog(http://kmsujit.blogspot.com/)
