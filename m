Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1ISJKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:10:40 -0400
Received: from relay.medianet-world.de ([213.157.0.172]:54085 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753490Ab1ISJKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:10:39 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Sep 2011 05:10:39 EDT
Thread-Index: Acx2qw4Ta/TU1S87T3a5AgmxDFUnIg==
Thread-Topic: [ANNOUNCE] 3.0.4-rt14
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Thomas Gleixner" <tglx@linutronix.de>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0.4-rt14
Date: Mon, 19 Sep 2011 11:03:52 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.3; KDE/4.4.5; x86_64; ; )
Cc: "LKML" <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.02.1109150047290.2723@ionos>
In-Reply-To: <alpine.LFD.2.02.1109150047290.2723@ionos>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-ID: <201109191103.52843.tim.sander@hbm.com>
X-OriginalArrivalTime: 19 Sep 2011 09:03:53.0249 (UTC) FILETIME=[0DF42110:01CC76AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas

Thanks for the new release. We've been testing your release here. We found 
that the minimum timer resolution on a vanilla 3.0.4-rt14 is about 16ms. I 
tried switching on hr timers but even with them the timer behaviour was the 
same. So i suspect that there is something strange going on concerning the 
timers. The tests done where on the pcm04 arm11 platform.

Best regards
Tim

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.

