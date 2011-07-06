Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1GFHtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 03:49:00 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:38936 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1GFHs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 03:48:59 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.11 with qID p667mqn8000485, This message is released by code: ctaloc0852
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1309859095-32031-1-git-send-email-hayeswang@realtek.com> <1309859095-32031-2-git-send-email-hayeswang@realtek.com> <20110705185515.GB5105@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next 2/6] r8169: modify the flow hw reset
Date: Wed, 6 Jul 2011 15:48:51 +0800
X-BOX-Message-Id: p667mqn8000485
Message-ID: <EF32BED7323642F29CF5AA3EA7048C78@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Acw7RwyAI4neotHBQlicRHcMcKzXuQAaC/Eg
In-Reply-To: <20110705185515.GB5105@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Wednesday, July 06, 2011 2:55 AM
> To: Hayeswang
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next 2/6] r8169: modify the flow hw reset
> 
> >  
> > +static void rtl_rx_close(struct rtl8169_private *tp) {
> > +	void __iomem *ioaddr = tp->mmio_addr;
> > +	u32 rxcfg = RTL_R32(RxConfig);
> > +
> > +	rxcfg &= ~(AcceptBroadcast | AcceptMulticast |
> > +		   AcceptMyPhys | AcceptAllPhys);
> > +	RTL_W32(RxConfig, rxcfg);
> > +}
> > +
> 
> Should not error and runt packets be considered too ?
> 
> <shot in the dark>
> Is there any relationship with commit 
> ca52efd5490f97f396d3c5863ba714624f272033 ?
> </shot in the dark>
> 

No, there is no relationship about that.

