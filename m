Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508Ab2HVNPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 09:15:44 -0400
Received: from relay.medianet-world.de ([213.157.0.172]:42924 "HELO
	relay.medianet-world.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751972Ab2HVNPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 09:15:42 -0400
thread-index: Ac2AZ0tG+DSMWg4KQ0+n2mLJcUWpeA==
Thread-Topic: [ANNOUNCE] 3.4.9-rt17
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
From: "Tim Sander" <tim.sander@hbm.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
        "RT" <linux-rt-users@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Carsten Emde" <C.Emde@osadl.org>, "John Kacur" <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.4.9-rt17
Date: Wed, 22 Aug 2012 15:08:59 +0200
Message-ID: <1843545.6vtXSYEOLB@dabox>
Organization: Hottinger Baldwin Messtechnik
User-Agent: KMail/4.8.4 (Linux/3.4.0; KDE/4.8.4; x86_64; ; )
In-Reply-To: <10950377.h1F1h7Gs2a@dabox>
References: <1345144963.3708.1.camel@gandalf.local.home> <10950377.h1F1h7Gs2a@dabox>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset="us-ascii"
X-OriginalArrivalTime: 22 Aug 2012 13:08:59.0589 (UTC) FILETIME=[4B3D0750:01CD8067]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rt-Folks

I just found out that the name of the rt irq of the fec device changed so it 
had the same rtprio as my measurement interrupt. With the rt prios fixed the 
performance seems to be roughly like the 3.0 kernel. If will give a further 
update if there are any findings.

Best regards
Tim

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich fur den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.
