Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1HJQeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 12:34:20 -0400
Received: from gateway.hbm.com ([213.157.30.2]:17824 "EHLO hbmntx5.hbm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab1HJQeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 12:34:11 -0400
Thread-Index: AcxXe1RvO1gd3wDnR0CjJRjQrdiAwQ==
Thread-Topic: [ANNOUNCE] 3.0-rt7 - Error with low latency desktop config
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Content-class: urn:content-classes:message
Importance: normal
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [ANNOUNCE] 3.0-rt7 - Error with low latency desktop config
Date: Wed, 10 Aug 2011 18:33:54 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.4.5; x86_64; ; )
Cc: "Peter Zijlstra" <peterz@infradead.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <1312465990.16729.22.camel@twins> <201108091707.49832.tim.sander@hbm.com> <20110809173310.GB11398@pengutronix.de>
In-Reply-To: <20110809173310.GB11398@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-ID: <201108101833.54661.tim.sander@hbm.com>
X-OriginalArrivalTime: 10 Aug 2011 16:34:09.0455 (UTC) FILETIME=[545803F0:01CC577B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe

I triple checked.
> I think targetinstall should ask about the changed config items.
It only asks one way, when going from an upatched kernel to an patched one.
Since i was coming from an preempt rt kernel to an unpatched one no questions
where asked (probably since all settings where still in place as i wasn't 
using the preempt rt feature with the preempt rt patched kernel source
aka "Low latency desktop")

> check if ${PROJECT_DIR}/${PLATFORMNAME}/build/linux-3.0/ (or similar)
> really has the rt patch applied. (e.g. is there a localversion-rt file?)
Yes, one version has rt7 appended the other not.

But i think the regression when going from 3.0-rt7 to 3.0.1-rt8 with 
CONFIG_PREEMPT_RTB is more worthwhile to discuss. Which i detailed in the 
other mail.

Best regards
Tim

Sorry for the noise:

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.

