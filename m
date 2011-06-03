Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1FCKsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 06:48:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:35327 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab1FCKsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 06:48:21 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Alexey ORISHKO <alexey.orishko@stericsson.com>
Subject: Re: [PATCH] TODO FLAG_POINTTOPOINT => FLAG_WWAN? usbnet/cdc_ncm: mark ncm devices as "mobile broadband devices" with FLAG_WWAN
Date: Fri, 3 Jun 2011 12:50:27 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Dan Williams <dcbw@redhat.com>, Stefan Metzmacher <metze@samba.org>,
        Oliver Neukum <oliver@neukum.name>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1306922913-17803-1-git-send-email-metze@samba.org> <201106031201.21933.oneukum@suse.de> <2AC7D4AD8BA1C640B4C60C61C8E520153E3C13B620@EXDCVYMBSTM006.EQ1STM.local>
In-Reply-To: <2AC7D4AD8BA1C640B4C60C61C8E520153E3C13B620@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201106031250.28041.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 3. Juni 2011, 12:23:21 schrieb Alexey ORISHKO:

> There is no difference between cdc_ncm and cdc_ether devices, besides
> the fact cdc_ncm is more efficient in data transfer and cpu load.
> The problem is that you cannot say much about device functionality based
> just on interface name. As example existing devices with cdc_ether 
> interface could be mobile phone which provides connectivity to 3G network,
> or could be a phone in the mode "over PC", where phone applications
> access internet via broadband connection on PC (to save money).
> 
> Network manager cannot simply make decision which devices can be used
> for mobile broadband access based on interface name. It needs an additional
> info, which does not exist in device descriptor. 

Well, but cdc-ether usually means that you can start up dhcp and use the
interface as a network card. Can the same be done with cdc-ncm or do you always
need to establish a connection through a secondary interface?

	Regards
		Oliver
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
