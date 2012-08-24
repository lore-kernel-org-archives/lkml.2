Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab2HXIca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 04:32:30 -0400
Received: from relay.medianet-world.de ([213.157.0.172]:21932 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751493Ab2HXIcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 04:32:25 -0400
thread-index: Ac2B0vmYFMvBhnRLTIOjYyCIfsooAw==
Thread-Topic: [ANNOUNCE] 3.4.9-rt17
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
From: "Tim Sander" <tim.sander@hbm.com>
To: "RT" <linux-rt-users@vger.kernel.org>
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
        "LKML" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Carsten Emde" <C.Emde@osadl.org>, "John Kacur" <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.4.9-rt17
Date: Fri, 24 Aug 2012 10:32:14 +0200
Message-ID: <1494830.WYyVmtosNh@dabox>
Organization: Hottinger Baldwin Messtechnik
User-Agent: KMail/4.8.4 (Linux/3.4.0; KDE/4.8.4; x86_64; ; )
In-Reply-To: <1843545.6vtXSYEOLB@dabox>
References: <1345144963.3708.1.camel@gandalf.local.home> <10950377.h1F1h7Gs2a@dabox> <1843545.6vtXSYEOLB@dabox>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset="iso-8859-1"
X-OriginalArrivalTime: 24 Aug 2012 08:32:19.0345 (UTC) FILETIME=[F98C5010:01CD81D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

After fixing the realtime prios which got shuffled due to other irq thread names
I just tested the realtime latency for interrupts on the i.mx35. With our own 
systemtimer which does not get into the way of  the measurement interrupt this 
kernel has 30µs worst time (caveat: short measurement period) interrupt 
latency and usermode can keep up with a 2400kHz interrupt rate. While the 
usermode performance seems to be largely unchanged (but i haven't tested very 
thoroughly) the interrupt latency went down about 10µs coming from the 3.0-rt 
series. Its really nice to see that kind of improvement. 

Thanks
Tim

Ignore the legalese please:


Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.
