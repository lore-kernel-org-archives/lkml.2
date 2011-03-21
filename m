Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab1CUCrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 22:47:45 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:39679 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1CUCrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 22:47:42 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.07 with qID p2L2l3Db018285, This message is released by code: ctlocs8528
From: hayeswang <hayeswang@realtek.com>
To: <piotr@hosowicz.com>, "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: "'Mike Galbraith'" <efault@gmx.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>, <benh@debian.org>
References: <201103101209.p2AC9YdZ014233@violet.fr.zoreil.com> <20110316202220.GA14741@electric-eye.fr.zoreil.com> <4D8244F4.3020500@example.com>
Subject: RE: Where to get the network NIC's firmware? rtl_nic/rtl8105e-1.fw
Date: Mon, 21 Mar 2011 10:47:03 +0800
X-BOX-Message-Id: p2L2l3Db018285
Message-ID: <7F300D72A54145B2BC4AF2E1CBE0CA10@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcvnZcBXPCI1tDjFQxOev3EmjKeqHQACeSwg
In-Reply-To: <4D8244F4.3020500@example.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Piotr Hosowicz [mailto:piotr@hosowicz.com] 
> Sent: Friday, March 18, 2011 1:29 AM
> To: Francois Romieu
> Cc: Mike Galbraith; LKML; Hayeswang; benh@debian.org
> Subject: Re: Where to get the network NIC's firmware? 
> rtl_nic/rtl8105e-1.fw
> 
> On 16.03.2011 21:22, Francois Romieu wrote:
> > You can get it there:
> >
> > 
> http://git.kernel.org/pub/scm/linux/kernel/git/romieu/linux-firmware.g
> > it 
> > 
> git://git.kernel.org/pub/scm/linux/kernel/git/romieu/linux-firmware.gi
> > t
> >
> > It has already been submitted to the maintainer of linux-firmware.
> 
> Hello,
> 
> The problem persists, I have on disk:
> 
> # ls /lib/firmware/rtl_nic/
> rtl8105e-1.fw  rtl8168d-1.fw  rtl8168d-2.fw  rtl8168e-1.fw  
> rtl8168e-2.fw
> 

Excuse me. I don't understand what your question is. Do you mean you cannot
build the kernel without the firmware? Or, you just don't know where to download
the firmware? Or, your NIC work abnormally after loading the firmware?

>From your information, I see the firmware in the correct path
"/lib/firmeare/rtl_nic/", so it seems fine.
 
Best Regards,
Hayes


> And my NIC doesn't work. What do you mean saying that I can 
> get it there? How can I contact the maintainer?
> 
> Please, help, I cannot test new kernels.
> 

