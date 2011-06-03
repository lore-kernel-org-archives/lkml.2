Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1FCJ7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 05:59:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34078 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab1FCJ7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:59:11 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Alexey ORISHKO <alexey.orishko@stericsson.com>
Subject: Re: [PATCH] TODO FLAG_POINTTOPOINT => FLAG_WWAN? usbnet/cdc_ncm: mark ncm devices as "mobile broadband devices" with FLAG_WWAN
Date: Fri, 3 Jun 2011 12:01:21 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Dan Williams <dcbw@redhat.com>, Stefan Metzmacher <metze@samba.org>,
        Oliver Neukum <oliver@neukum.name>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1306922913-17803-1-git-send-email-metze@samba.org> <5203.1307062683@turing-police.cc.vt.edu> <2AC7D4AD8BA1C640B4C60C61C8E520153E3C13B5F2@EXDCVYMBSTM006.EQ1STM.local>
In-Reply-To: <2AC7D4AD8BA1C640B4C60C61C8E520153E3C13B5F2@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106031201.21933.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 3. Juni 2011, 11:45:38 schrieb Alexey ORISHKO:
> > -----Original Message-----
> > From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
> > Sent: Friday, June 03, 2011 2:58 AM
> > 
> > > A follow-on to this is that if you really care about specific
> > devices,
> > > your application can use udev rules to "tag" specific interfaces
> > based
> > > on USB VID/PID/GUID or other device attributes, and check for those
> > > tags in your program.  Use udev (good) or netlink (good) or
> > > SIOCGIFCONF (bad) to enumerate the various network interfaces on the
> > > system and pick the
> > 
> > I think Alexey's point was that the patch will hose up programs that
> > currently do the netlink or  SIOCGIFCONF thing and look for
> > FLAG_POINTTOPOINT.
> 
> Just to clarify, I was objecting to renaming interface name mostly because
> devices which use CDC NCM function might be something different from wwan
> devices. I would prefer to keep a generic name of interface (usbX or ethX).
> 
> As an option anyone can use udev rules to set interface name they want 
> for their device based on VID/PID or MAC address or something else.
> I've already provided udev rule example earlier in this thread.

This is not ideal. Distributions cannot care about every VIP:PID value.
If a device with an NCM interface needs to be treated in a special
manner we'd better have a special name for such interfaces.

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
