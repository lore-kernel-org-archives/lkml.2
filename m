Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab2AXImJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 03:42:09 -0500
Received: from relay.medianet-world.de ([213.157.0.172]:22653 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754994Ab2AXImH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 03:42:07 -0500
thread-index: Aczac/baWKi3TxkJRiWMR+pw1d4+Ww==
Thread-Topic: [PATCH RT 0/4] [ANNOUNCE] 3.0.14-rt32-rc1
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH RT 0/4] [ANNOUNCE] 3.0.14-rt32-rc1
Date: Tue, 24 Jan 2012 09:40:38 +0100
User-Agent: KMail/1.13.5 (Linux/3.0.3; KDE/4.4.5; x86_64; ; )
Cc: <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Carsten Emde" <C.Emde@osadl.org>, "John Kacur" <jkacur@redhat.com>
References: <20120118034531.335521323@goodmis.org> <201201181450.17680.tim.sander@hbm.com> <1326901314.17534.81.camel@gandalf.stny.rr.com>
In-reply-to: <1326901314.17534.81.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="ISO-8859-15"
Content-Transfer-Encoding: 8BIT
Message-ID: <201201240940.38825.tim.sander@hbm.com>
X-OriginalArrivalTime: 24 Jan 2012 08:41:28.0313 (UTC) FILETIME=[F6C56E90:01CCDA73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve

I haven't found the time to test the newer release but i still have some 
feedback for the "older" stuff.
> > > This is the RT stable review cycle of patch 3.0.14-rt32-rc1.
> > > 
> > > Please scream at me if I messed something up. Please test the patches
> > > too.
> > Well the error i described in other mails to this list are still
> > persistent: * ksoftirq running wild due to fec ethernet tx interrupt.
> 
> I would be surprised if it went away, as none of these patches would
> have touched that code.
> 
> > Does patch nr 2 possibly fix the error reboot fails with "Unable to
> > execute shutdown: Bad address". The error occurs not to often so it is
> > hard to say if this 3.0.14-rt32 is still showing this error.
> 
> Honestly I don't know about that error. But wait queues have been a
> thorn in -rt for a while, and this patch fixes a few areas I'm sure.
> That being one of them, I guess you'll find out if you see the bug
> again ;-)
Well i just found out, the error is still present :-(. The process start of 
reboot sometimes just fails with a "Bad address" error. I think this behaviour 
is there in all 3.0.x-rt releases. This is on arm i.xm35 pcm42 platform. I 
currently have no Idea where this error comes from but i would be happy for 
any input. I suspect that this error is happening with other processes than 
reboot. I suspect that failing konqueror ssh client sessions with "fish://" 
also are failing due to this error. Unfortunatly no hard evidence for this.

Best regards
Tim

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.
