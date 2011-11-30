Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab1K3Ir2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 03:47:28 -0500
Received: from relay.medianet-world.de ([213.157.0.172]:40176 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752383Ab1K3IrY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 03:47:24 -0500
thread-index: AcyvPKzn95t2spTERLCrDLCQ2Ko2JQ==
Thread-Topic: [PATCH RT] tasklet/rt: Prevent tasklets from going into infinite spin in RT
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH RT] tasklet/rt: Prevent tasklets from going into infinite spin in RT
Date: Wed, 30 Nov 2011 09:46:52 +0100
User-Agent: KMail/1.13.5 (Linux/3.0.3; KDE/4.4.5; x86_64; ; )
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        "RT" <linux-rt-users@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        "Clark Williams" <williams@redhat.com>
References: <1322618120.17003.104.camel@frodo>
In-Reply-To: <1322618120.17003.104.camel@frodo>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <201111300946.53146.tim.sander@hbm.com>
X-OriginalArrivalTime: 30 Nov 2011 08:47:21.0880 (UTC) FILETIME=[ACCB3980:01CCAF3C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven
> I booted this patch against 3.0-rt stable, and it didn't crash ;)
> Could you apply it and see if it fixes the hang that you've been seeing.
Unfortunatly i am also experiencing these problems with ksoftirq running wild.

So i am also going to test this patch and see if it fixes our problem. It seems 
as if this bug is much more probable after UBIFS update and when 
"sched: RT throttling activated" hits.

Best regards
Tim

PS: Steven i just forgot the cc list so you got this mail twice, sorry.

Please ignore or at your wish use as "Deutschkurs" in german legalese:

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.
