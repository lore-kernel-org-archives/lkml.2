Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab1KKKKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 05:10:15 -0500
Received: from relay.medianet-world.de ([213.157.0.172]:12803 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751350Ab1KKKKN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 05:10:13 -0500
Thread-Index: AcygWEuRDbM5sNieSriKOpKmMJ/yzA==
Thread-Topic: RT Throtteling with PREEMT-RT on UBIFS root fs update
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "linux-rt-users" <linux-rt-users@vger.kernel.org>
Subject: RT Throtteling with PREEMT-RT on UBIFS root fs update
Date: Fri, 11 Nov 2011 10:56:53 +0100
User-Agent: KMail/1.13.5 (Linux/3.0.3; KDE/4.4.5; x86_64; ; )
Cc: "LKML" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-ID: <201111111056.53803.tim.sander@hbm.com>
X-OriginalArrivalTime: 11 Nov 2011 09:57:17.0008 (UTC) FILETIME=[4B6FB500:01CCA058]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

We are having a problem with a slightly patched (some platform patches,
newest stable ubifs patches) 3.0.7-rt20 kernel after updating the firmware on 
the first boot we get a message:
sched: RT throttling activated
and ksoftirqd/0 taking 95% of the cpu time.

Interestingly this only happens after the ubifs root has been updated on the 
first boot (and not allways). Subsequent boot problems have not been seen.

Any ideas whats causing this?
Tim

Sorry for noise below, please ignore:

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich fur den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.
