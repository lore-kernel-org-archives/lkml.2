Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1EYR2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 13:28:22 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:59070
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751621Ab1EYR2V convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 13:28:21 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 May 2011 13:28:21 EDT
Reply-To: <wyrles@ytram.com>
From: "Tom Allebrandi" <wyrles@ytram.com>
To: "'Cufi, Carles'" <carles.cufi@nordicsemi.no>, <corey@kansanian.com>
Cc: "'Ed Tomlinson'" <edt@aei.ca>, "'Ville Tervo'" <ville.tervo@nokia.com>,
        "'Bluettooth Linux'" <linux-bluetooth@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <BANLkTinG_qCtHQYRYFQUJ9oGv4H1cuznWg@mail.gmail.com> <201105250711.17971.edt@aei.ca>	<20110525113614.GQ2480@null> <201105250812.43246.edt@aei.ca> <5B4B9A479BF6994B88EA975675EC5B79057A399D82@MES1OS2SXC003.mes1.tconet.net> <BANLkTi=ec3bh24=2r8f3tmj2g0n0bMnq1Q@mail.gmail.com> <5B4B9A479BF6994B88EA975675EC5B79057A60296D@MES1OS2SXC003.mes1.tconet.net> <013c01cc1af9$361b00e0$a25102a0$@ytram.com> <5B4B9A479BF6994B88EA975675EC5B79057A6029C4@MES1OS2SXC003.mes1.tconet.net>
In-Reply-To: <5B4B9A479BF6994B88EA975675EC5B79057A6029C4@MES1OS2SXC003.mes1.tconet.net>
Subject: RE: Linux 2.6.39
Date: Wed, 25 May 2011 10:21:53 -0700
Message-ID: <019601cc1b00$52f91fb0$f8eb5f10$@ytram.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQGUKt7R/T/916P1fB9/N50PhgUuCwGLqzLiAU0RkDMBZ9ryawGkHAjPAqaiMpsCHZd2SACsfoNwAmFbiAOUn/PIcA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> > Read Local Version Information (0x04|0x0001) plen 0
> >> > > HCI Event: Command Complete (0x0e) plen 12
> >> >     Read Local Version Information (0x04|0x0001) ncmd 1
> >> >     HCI Version: 1.1 (0x1) HCI Revision: 0x20d
> >> >     LMP Version: 1.1 (0x1) LMP Subversion: 0x20d
> >> >     Manufacturer: Cambridge Silicon Radio (10) < HCI Command: Set
> >> > Event Mask (0x03|0x0001) plen 8
> >> >     Mask: 0xfffffbff00000000
> 
> The HCI spec lists this as a 64-bit number but it must be sent in Little
Endian to
> the controller, hence the reverse order in Ville Tervo's patch earlier in
the
> email thread.

That I knew. I was just checking that 64 bit values are displayed left to
right since other little endian values (0x020d, 0x0001 above) are displayed
right to left.

Cheers!

--- tom
tom allebrandi
wyrles@ytram.com


