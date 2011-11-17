Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab1KQNzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 08:55:47 -0500
Received: from relay.medianet-world.de ([213.157.0.172]:61610 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757643Ab1KQNzp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 08:55:45 -0500
Thread-Index: AcylMHiKka8Hb6bISyalnnnvWMsktA==
Thread-Topic: RT Throtteling with PREEMT-RT on UBIFS root fs update
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "linux-rt-users" <linux-rt-users@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: RT Throtteling with PREEMT-RT on UBIFS root fs update
Date: Thu, 17 Nov 2011 14:54:18 +0100
User-Agent: KMail/1.13.5 (Linux/3.0.3; KDE/4.4.5; x86_64; ; )
References: <201111111056.53803.tim.sander@hbm.com>
In-Reply-To: <201111111056.53803.tim.sander@hbm.com>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-ID: <201111171454.18742.tim.sander@hbm.com>
X-OriginalArrivalTime: 17 Nov 2011 13:54:44.0173 (UTC) FILETIME=[75E30FD0:01CCA530]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

This is just a followup 
> We are having a problem with a slightly patched (some platform patches,
> newest stable ubifs patches) 3.0.7-rt20 kernel after updating the firmware
> on the first boot we get a message:
> sched: RT throttling activated
> and ksoftirqd/0 taking 95% of the cpu time.
RT throtteling is still activate with 3.0.9-rt25 (+ ubifs stable patches) but 
now  ksoftirqd/0 is not going berserk.
> Interestingly this only happens after the ubifs root has been updated on
> the first boot (and not allways). Subsequent boot problems have not been
> seen.
Ok the only nitpik that is left, that the processor activates rt throtteling 
after the first boot with updated ubifs image. 
> Any ideas whats causing this?
Well it can be said that it is not ksoftirqd/0 going berserk which is 
triggering this. So i guess when this message is printed it just shows that 
the cpu had been temporarily overloded with work in interrupt context.
Is there more harm to expect from this message or save to ignore if the 
systemload is normal again?

Best regards
Tim
 
> Sorry for noise below, please ignore:

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.
