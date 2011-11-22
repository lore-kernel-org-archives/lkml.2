Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab1KVJer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:34:47 -0500
Received: from relay.medianet-world.de ([213.157.0.172]:14431 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752583Ab1KVJeo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:34:44 -0500
Thread-Index: Acyo+fbdvU37Pr4ATLWeJ2kJ2qIDIg==
Thread-Topic: [ANNOUNCE] 3.2-rc1-rt1 - Compile errors also for rc1 vanilla
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
Content-class: urn:content-classes:message
Importance: normal
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [ANNOUNCE] 3.2-rc1-rt1 - Compile errors also for rc1 vanilla
Date: Tue, 22 Nov 2011 10:34:15 +0100
User-Agent: KMail/1.13.5 (Linux/3.0.3; KDE/4.4.5; x86_64; ; )
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>,
        "John Kacur" <jkacur@redhat.com>
References: <alpine.LFD.2.02.1111132213220.2694@ionos> <201111141014.06906.tim.sander@hbm.com> <1321896657.20742.16.camel@frodo>
In-Reply-To: <1321896657.20742.16.camel@frodo>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <201111221034.16018.tim.sander@hbm.com>
X-OriginalArrivalTime: 22 Nov 2011 09:34:42.0769 (UTC) FILETIME=[F6CA7C10:01CCA8F9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve
> arch/arm/mach-imx/built-in.o: In function `imx31_soc_init':
> /work/rt/rt.git/arch/arm/mach-imx/mm-imx3.c:186: undefined reference to
> `mx31_revision' make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [sub-make] Error 2
> 
> Which is not the error you saw. I'm curious to what I did wrong.
As i wrote i had some platform modifications which i took from my 3.0 kernel.
When compiling vanilla 3.2-rc2 i have the same error as you above.

I've just send an error report to the arm kernel mailing list.

Best regards
Tim

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.
