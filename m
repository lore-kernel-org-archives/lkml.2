Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab2JXFzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:55:43 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:50969 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2JXFzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:55:42 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q9O5tTIc001663, This message is released by code: ctlocs8528
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1350893153-18320-1-git-send-email-hayeswang@realtek.com> <1350974831-1438-1-git-send-email-hayeswang@realtek.com> <20121023193304.GB10463@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH v2 net-next 1/2] r8169: enable ALDPS for power saving
Date: Wed, 24 Oct 2012 13:55:28 +0800
Message-ID: <F44332CBDDB64F93B0BB3785EC1AD46E@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac2xWC50UAdEz2QFS/2RZvY1GyFloAAU3Tqw
In-Reply-To: <20121023193304.GB10463@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Francois Romieu [mailto:romieu@fr.zoreil.com] 
[...]
> > +static void r810x_aldps_disable(struct rtl8169_private *tp)
> > +{
> > +	rtl_writephy(tp, 0x1f, 0x0000);
> > +	rtl_writephy(tp, 0x18, 0x0310);
> > +	msleep(100);
> > +}
> 
> rtl8402_hw_phy_config used a msleep(20). Meguesses it won't 
> hurt, right ?

No, it won't hurt. The delay make suer there is enough time to pause ALDPS.
 
Best Regards,
Hayes

