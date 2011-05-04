Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1EDNzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:55:08 -0400
Received: from sputnik.urmx.de ([88.198.51.18]:52526 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556Ab1EDNzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:55:07 -0400
X-Spam-Processed: srv201.gdsys.de, Wed, 04 May 2011 15:55:02 +0200
	(not processed: message from trusted or authenticated source)
X-Return-Path: Eibach@gdsys.de
X-Envelope-From: Eibach@gdsys.de
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4721
Date: Wed, 4 May 2011 15:54:58 +0200
Message-ID: <48D3D52125C49B43AE880038E2E5314BB5BE9E@SRV101.gdsys.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-index: AcwKYGwju+YTVoW+R+OEaw7J6HYJUwAAbbrg
References: <48D3D52125C49B43AE880038E2E5314BB5BE9D@SRV101.gdsys.de> <4DC1568B.2080004@gmail.com>
From: "Eibach, Dirk" <Eibach@gdsys.de>
To: "Jiri Slaby" <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
X-SafeGuard_MailGateway: Version: 5.60.3.10058 SGMG Date: 20110504135505Z
Subject: RE: msleep() an load average
Thread-Topic: RE: msleep() an load average
Content-Class: urn:content-classes:message
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.4.226; VDF: 7.11.7.147; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > while(1) msleep_interruptible(1000);
> > 
> > I appreciate their admiration, but still there are doubts 
> in my mind: 
> > Is this code really any better?
> 
> Try to send it a signal, it will eat 100% of CPU without sleeping.

As I am a great kernel hacker, all signals are blocked ;)

> > Is the loadavg metric broken beyond repair?
> 
> No, this is expected behaviour. Uninterruptible sleeps count 
> as I/O load.

Ah, now we come to the point. Is there any practical reason behind this
or was it just an igenious invention to annoy those smug userspace
developers? I don't see any real world I/O load here.

> regards,
> --
> js

Cheers
Dirk


