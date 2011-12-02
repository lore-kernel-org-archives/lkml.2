Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab1LBCVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:21:25 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:58709 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1LBCVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:21:24 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.15 with qID pB22L8vG024211, This message is released by code: ctlocs8528
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <booster@wolke7.net>, "'Jonathan Nieder'" <jrnieder@gmail.com>,
        "'Eric Dumazet'" <eric.dumazet@gmail.com>, <netdev@vger.kernel.org>,
        "'nic_swsd'" <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        "'Armin Kazmi'" <armin.kazmi@tu-dortmund.de>
References: <20111125201936.GA26692@elie.hsd1.il.comcast.net> <1322253122.2550.3.camel@edumazet-laptop> <20111125222211.GA13719@electric-eye.fr.zoreil.com> <1322262357.2550.12.camel@edumazet-laptop> <20111126004447.GA14744@electric-eye.fr.zoreil.com> <1322280423.10212.3.camel@edumazet-laptop> <20111127092808.GE21635@elie.hsd1.il.comcast.net> <4ED2A573.1020807@wolke7.net> <20111127231147.GA1784@electric-eye.fr.zoreil.com> <D95C09DB1A7E493E89FE5A0B3879CEB0@realtek.com.tw> <20111129105440.GA2410@electric-eye.fr.zoreil.com>
Subject: RE: [bug?] r8169: hangs under heavy load
Date: Fri, 2 Dec 2011 10:21:08 +0800
Message-ID: <FCF60BC8872E4F1C9C72CE56F0E570C0@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcyuhiyHvp6Y1/EVR6qmio0m7OqoygCESGYg
In-Reply-To: <20111129105440.GA2410@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu [mailto:romieu@fr.zoreil.com] 
[...]
> > For the 8168c and the later chips, our hardware engineer 
> says that don't enable
> > the RxFIFOOver of IntrMask and don't clear the RxFIFOOver 
> of IntrStatus. The
> > hardware will automatically escape Rx fifo full situation. 
> Although you try to
> > clear the RxFIFOOver of IntrStatus, maybe the bit wouldn't 
> be cleared. Just
> > disregard it.
> 
> Should "later" be understood as gigabit PCI-E only or is 
> there a similar
> difference of behavior between older fast-ethernet PCI-E and 
> more recent
> ones ?
> 

For the fast controller, it should start from rtl8105e. 

Best Regards,
Hayes

