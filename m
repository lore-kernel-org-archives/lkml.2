Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567Ab2ARN5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:57:43 -0500
Received: from relay.medianet-world.de ([213.157.0.172]:21273 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757546Ab2ARN5l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 08:57:41 -0500
thread-index: AczV6DlE3JPdB0K3SvW3sofO+en65w==
Thread-Topic: [PATCH RT 0/4] [ANNOUNCE] 3.0.14-rt32-rc1
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH RT 0/4] [ANNOUNCE] 3.0.14-rt32-rc1
Date: Wed, 18 Jan 2012 14:50:17 +0100
User-Agent: KMail/1.13.5 (Linux/3.0.3; KDE/4.4.5; x86_64; ; )
Cc: <linux-kernel@vger.kernel.org>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Carsten Emde" <C.Emde@osadl.org>, "John Kacur" <jkacur@redhat.com>
References: <20120118034531.335521323@goodmis.org>
In-reply-to: <20120118034531.335521323@goodmis.org>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="ISO-8859-15"
Content-Transfer-Encoding: 8BIT
Message-ID: <201201181450.17680.tim.sander@hbm.com>
X-OriginalArrivalTime: 18 Jan 2012 13:51:05.0555 (UTC) FILETIME=[39311A30:01CCD5E8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve
> This is the RT stable review cycle of patch 3.0.14-rt32-rc1.
> 
> Please scream at me if I messed something up. Please test the patches too.
Well the error i described in other mails to this list are still persistent:
* ksoftirq running wild due to fec ethernet tx interrupt.

Does patch nr 2 possibly fix the error reboot fails with "Unable to execute 
shutdown: Bad address". The error occurs not to often so it is hard to say if 
this 3.0.14-rt32 is still showing this error.

Best regards
Tim

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.
