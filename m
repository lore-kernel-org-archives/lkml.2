Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab1HIPIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:08:07 -0400
Received: from gateway.hbm.com ([213.157.30.2]:54418 "EHLO hbmntx5.hbm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1HIPIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:08:06 -0400
Thread-Index: AcxWpiMof+JyVU/iS6epDU+EVETgAg==
Thread-Topic: [ANNOUNCE] 3.0-rt7 - Error with low latency desktop config
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Content-class: urn:content-classes:message
Importance: normal
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [ANNOUNCE] 3.0-rt7 - Error with low latency desktop config
Date: Tue, 9 Aug 2011 17:07:49 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.4.5; x86_64; ; )
Cc: "Peter Zijlstra" <peterz@infradead.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <1312465990.16729.22.camel@twins> <201108091548.06875.tim.sander@hbm.com> <20110809140923.GA11398@pengutronix.de>
In-Reply-To: <20110809140923.GA11398@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-ID: <201108091707.49832.tim.sander@hbm.com>
X-OriginalArrivalTime: 09 Aug 2011 15:08:03.0977 (UTC) FILETIME=[2310DF90:01CC56A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe

I just double checked.
> The config doesn't look like a 3.0-rt7 one. There is neither
> 
> 	PREEMPT_RTB=y
> 
> nor
> 
> 	# PREEMPT_RTB is not set
If i switch the configs with "Kernel Feature"-> "Preemption Model" -
>"(Preemtible Kernel) Low-Latency Desktop"
there are no such config options visible even with a -rt7 kernel.
(My workflow in ptxdist is
comment (in/out) rtpatch in patches/linux-3.0/series
ptxdist clean kernel && ptxdist targetinstall kernel
deploy.sh

Otherwise ptxdist would cheat on me and at 
$(PROJECT_DIR)/configs/$(PLATFORM)/kernelconfig would be out of sync.)

Best regards
Tim


Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.

