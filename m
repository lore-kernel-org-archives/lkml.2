Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab2GDJC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 05:02:29 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:46039 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab2GDJCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 05:02:25 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q6492GgK006782, This message is released by code: ctlocs8528
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1340966060-2749-1-git-send-email-hayeswang@realtek.com> <1341221002-1522-1-git-send-email-hayeswang@realtek.com> <20120703110101.GA4779@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH v2 net-next 1/2] r8169: support RTL8106E
Date: Wed, 4 Jul 2012 17:02:17 +0800
Message-ID: <C4FBD4FA06A3458594FEA8117B2274B6@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac1ZDLbd/5d7ryhCT9u7v+Rxy7NgmwAtGlwg
In-Reply-To: <20120703110101.GA4779@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu [mailto:romieu@fr.zoreil.com] 
[...]
> > +#define FIRMWARE_8106E_1	"rtl_nic/rtl8106e-1.fw"
> 
> I did not notice it. Was it submitted ?
> 

I don't submit it yet.

> It was obviously not required for testing :o)
> 
> > @@ -1933,6 +1941,8 @@ static void 
> rtl8169_get_mac_version(struct rtl8169_private *tp,
> >  		{ 0x7c800000, 0x30000000,	RTL_GIGA_MAC_VER_11 },
> >  
> >  		/* 8101 family. */
> > +		{ 0x7cf00000, 0x44900000,	RTL_GIGA_MAC_VER_39 },
> > +		{ 0x7c800000, 0x44800000,	RTL_GIGA_MAC_VER_39 },
> >  		{ 0x7c800000, 0x44000000,	RTL_GIGA_MAC_VER_37 },
> >  		{ 0x7cf00000, 0x40b00000,	RTL_GIGA_MAC_VER_30 },
> >  		{ 0x7cf00000, 0x40a00000,	RTL_GIGA_MAC_VER_30 },
> 
> Realtek's 1.022.00 8101 driver only maps { 0x7c800000; 0x44800000 } to
> a generic device - if at all - and it maps { 0x7cf00000; 0x44800000 }
> to a different chipset (namely CFG_METHOD_15 where RTL_GIGA_MAC_VER_39
> is CFG_METHOD_16).
> 
> Why should both drivers diverge ?
> 

Our PMs say only 0x44900000 would have mass production. Besides, you could use
the same setting for both of them. 

Best Regards,
Hayes

