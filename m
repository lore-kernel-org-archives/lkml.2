Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1FCJrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 05:47:11 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:58023 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423Ab1FCJrJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:47:09 -0400
From: Alexey ORISHKO <alexey.orishko@stericsson.com>
To: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Dan Williams <dcbw@redhat.com>
Cc: Stefan Metzmacher <metze@samba.org>, Oliver Neukum <oliver@neukum.name>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 3 Jun 2011 11:45:38 +0200
Subject: RE: [PATCH] TODO FLAG_POINTTOPOINT => FLAG_WWAN? usbnet/cdc_ncm:
 mark ncm devices as "mobile broadband devices" with FLAG_WWAN
Thread-Topic: [PATCH] TODO FLAG_POINTTOPOINT => FLAG_WWAN? usbnet/cdc_ncm:
 mark ncm devices as "mobile broadband devices" with FLAG_WWAN
Thread-Index: AcwhiV6P63zzPaaGSDOLVVJh0o/VywASG5tQ
Message-ID: <2AC7D4AD8BA1C640B4C60C61C8E520153E3C13B5F2@EXDCVYMBSTM006.EQ1STM.local>
References: <1306922913-17803-1-git-send-email-metze@samba.org>
 <1306922913-17803-2-git-send-email-metze@samba.org>
 <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E583@EXDCVYMBSTM006.EQ1STM.local>
 <1307053743.21633.22.camel@dcbw.foobar.com>
            <1307054132.21633.25.camel@dcbw.foobar.com>
 <5203.1307062683@turing-police.cc.vt.edu>
In-Reply-To: <5203.1307062683@turing-police.cc.vt.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
> Sent: Friday, June 03, 2011 2:58 AM
> 
> > A follow-on to this is that if you really care about specific
> devices,
> > your application can use udev rules to "tag" specific interfaces
> based
> > on USB VID/PID/GUID or other device attributes, and check for those
> > tags in your program.  Use udev (good) or netlink (good) or
> > SIOCGIFCONF (bad) to enumerate the various network interfaces on the
> > system and pick the
> 
> I think Alexey's point was that the patch will hose up programs that
> currently do the netlink or  SIOCGIFCONF thing and look for
> FLAG_POINTTOPOINT.

Just to clarify, I was objecting to renaming interface name mostly because
devices which use CDC NCM function might be something different from wwan
devices. I would prefer to keep a generic name of interface (usbX or ethX).

As an option anyone can use udev rules to set interface name they want 
for their device based on VID/PID or MAC address or something else.
I've already provided udev rule example earlier in this thread.

Dan, is it in line with your statement?

/alexey

