Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab0JOFKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 01:10:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22087 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab0JOFKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 01:10:23 -0400
Date: Fri, 15 Oct 2010 05:10:21 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH] Serial: BUGFIX: uart_resume_port has an omitted
 condition.
To: Stanislav Brabec <sbrabec@suse.cz>, Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Andr Goddard Rosa <andre.goddard@gmail.com>,
        Jason Wang <jason77.wang@gmail.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20101015050337741@myungjoo.ham
Msgkey: 20101015050337741@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20101015050337741@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <15814028.20691287119419827.JavaMail.weblogic@epv6ml08>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9F5Ac6A015374

> Greg KH wrote: 
> > > This disparity appeared deliberately in 4547be78. If you need
> > > no_console_suspend and the hardware lets the device in an undefined
> > > state after resume (i. e. PXA270), you need to call subset of the
> > > resume, even if the suspend counterpart was not called. Yes, I can
> > > imagine that it may be a source of problems.
> 
> > > It seems that support for no_console_suspend for all devices is becoming
> > > more complicated. I guess that a new driver calls (maybe "save_state"
> > > and "resume_state") or support for no_console_suspend directly in
> > > drivers may be useful.
> > 
> > Ok, so I'm guessing that this patch is not to be applied then, correct?
> 
> I just compared it with Jason Wang's patches. MyungJoo Ham's patch is
> exactly equal to the PATCH 1/2. So it already has my ACK and it is
> pending as:
> 
> serial-core: skip call set_termios/console_start when no_console_suspend
> 
> Related thread can be found in linux-serial archives from August 2010:
> [PATCH RESEND 0/2] two serial_core suspend/resume fixes
> 
> To MyungJoo Ham: Could you verify, that Jason Wang's patch 2/2 does not
> break your system? My patch to fix PXA270 does not exist yet. I'll ask
> you in future for testing.

With Jason Wang's patch, it works fine. I'm applying Wang's 1/2 and 2/2 to mine.

Thank you.

> 
> -- 
> Best Regards / S pozdravem,
> 
> Stanislav Brabec
> software developer
> ---------------------------------------------------------------------
> SUSE LINUX, s. r. o.                          e-mail: sbrabec@suse.cz
> Lihovarska 1060/12           tel: +420 284 028 966, +49 911 740538747
> 190 00 Praha 9                                  fax: +420 284 028 951
> Czech Republic                                    http://www.suse.cz/
> 





 MyungJoo Ham (ÇÔ¸íÁÖ)
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
