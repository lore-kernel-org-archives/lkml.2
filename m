Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab1LGIKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:10:33 -0500
Received: from relay.medianet-world.de ([213.157.0.172]:60527 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752229Ab1LGIKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:10:31 -0500
thread-index: Acy0t667AK0siGrVQg6fO3lBe7i7jg==
Thread-Topic: [PATCH 00/11] [ANNOUNCE] 3.0.12-rt30-rc2
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 00/11] [ANNOUNCE] 3.0.12-rt30-rc2
Date: Wed, 7 Dec 2011 09:09:56 +0100
User-Agent: KMail/1.13.5 (Linux/3.0.3; KDE/4.4.5; x86_64; ; )
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
        "Tim Sander" <tim01@vlsi.informatik.tu-darmstadt.de>,
        <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>,
        "Carsten Emde" <C.Emde@osadl.org>, "John Kacur" <jkacur@redhat.com>
References: <20111204185444.411298317@goodmis.org> <201112051011.59858.tim.sander@hbm.com> <1323091398.30977.74.camel@frodo>
In-Reply-To: <1323091398.30977.74.camel@frodo>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <201112070909.56992.tim.sander@hbm.com>
X-OriginalArrivalTime: 07 Dec 2011 08:10:28.0860 (UTC) FILETIME=[AE9F6BC0:01CCB4B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve
> > I should also point out, that this phenomen was not always happening, but
> > only sometimes and then again disapeared without any known reason.
> 
> Hmm, then are you sure that the tasklet patch causes the bug? Or perhaps
> it only changes the timing to cause it. The bug may be without the patch
> too.
Well, we are running the preempt rt patchset 3.0 since the rt-9 release and we 
have not seen this kind of error. It just started popping up after i applied 
the patch which i took directly from the mailing list when it was posted, 
since we had this ksoftirq issue especially after firmware update when ubifs 
has been updated.

The bad thing is that it is not happening deterministic but seemingly at 
random. But i will try your next prerelease and will report any results.

My patch is also not completly vanilla mainline. I am using the recomended 
patch from ubifs/master, some small platform patches and some timer patches 
Thomas Gleixner knows best about.

Best regards
Tim

Please ignore:

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.
