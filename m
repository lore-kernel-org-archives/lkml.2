Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab0FWGQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 02:16:56 -0400
Received: from antispam01.maxim-ic.com ([205.153.101.182]:36649 "EHLO
	antispam01.maxim-ic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab0FWGQz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 02:16:55 -0400
X-Greylist: delayed 1119 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jun 2010 02:16:55 EDT
X-ASG-Debug-ID: 1277272695-071ef9e10001-xx1T2L
X-Barracuda-Envelope-From: Dayananda.HB@maxim-ic.com
From: "Dayananda H.B." <Dayananda.HB@maxim-ic.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Dayananda H.B." <Dayananda.HB@maxim-ic.com>,
       "dayananda.hb@gmail.com" <dayananda.hb@gmail.com>
Date: Wed, 23 Jun 2010 00:58:34 -0500
X-ASG-Orig-Subj: USB Low speed device not working with full speed HUB connected to
 the USB OTG controller-1.1
Subject: USB Low speed device not working with full speed HUB connected to
 the USB OTG controller-1.1
Thread-Topic: USB Low speed device not working with full speed HUB connected
 to the USB OTG controller-1.1
Thread-Index: AQHLEpkRfBbMEAAwiEG7pSo5guuY9w==
Message-ID: <265A5FBCF63E4F4986A5C262DADBE85205376B9414@ITDALEX06.it.maxim-ic.internal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 23 Jun 2010 05:58:37.0235 (UTC) FILETIME=[1F2A4030:01CB1299]
X-Barracuda-Connect: terlingua.dalsemi.com[180.0.34.46]
X-Barracuda-Start-Time: 1277272695
X-Barracuda-URL: http://AntiSpam02.maxim-ic.com:8000/cgi-mod/mark.cgi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I am facing an issue as below, I have USB OTG Host controller-1.1 and I have connected the full speed HUB-2.0 is connected to the Host controller and then the low speed device (In my case Logitech Mouse) is connected. But as soon as I connect the low speed device
to the HUB, HUB gets reset continuously and it goes to infinite loop and ultimately  it is impossible to enumerate the Low speed device. 

I have taken the data log of the USB analyzer and I found Host controller sends the extra bytes(more than 30 bytes 0xFF) after the ACK(0xD2)
in the Get Device Descriptor request for IN TOKEN packet. HOST controller recieves 8 bytes data in the IN token and after that it sends
ACK (0xD2) and about 30 bytes of (0xFF) extra data.

If anybody knows this issue is coming from the USB stack (I am using the Linux-2.6.26 kernel) or the OTG HOST controller 1.1 or PRE amble PID/split packets please let me know.

Please CC while replying to mail.


Thanks and Regards
Dayananda
