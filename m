Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab1I2G5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 02:57:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63255 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388Ab1I2G5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 02:57:51 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-d0-4e8416e33140
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'santosh'" <santosh.iitg@gmail.com>
Cc: linux-kernel@vger.kernel.org
References: <CADUNanhyOg-mJtBQ1WFh_YfO0b73JEiOLLowC8fHbwgdkMDaHw@mail.gmail.com>
 <007201cc7e6f$6019b970$204d2c50$%kim@samsung.com>
 <CADUNanjVncrzeMofSMZGhKOcYu1qbh4ZcBjziOPFU+wkE6MXbw@mail.gmail.com>
In-reply-to: <CADUNanjVncrzeMofSMZGhKOcYu1qbh4ZcBjziOPFU+wkE6MXbw@mail.gmail.com>
Subject: RE: {Question] Is "kernel.org" down ?
Date: Thu, 29 Sep 2011 15:57:39 +0900
Message-id: <007801cc7e75$13dfcfd0$3b9f6f70$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acx+caToLvKqQr/dSVKKgdY/8+XGKAAAoIkA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Santosh wrote:
> 
> Kgene,
> 
> https://github.com/torvalds/linux.git
> 
> Thanks for your response. I could not find location in that site to
> download linux kernel.
> 
> I need  2.6.38 kernel source.  Can you please help me out ?
> 
Hi Santosh,

Please refer to below...

$ git clone git://github.com/torvalds/linux.git

$ cd linux

$ git checkout v2.6.38
Or $ git reset --hard v2.6.38
Or $ git checkout -b [local branch] v2.6.38

Actually, there are many ways and above is one of them...

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.


> Thanks
> Santosh
> 
> On Thu, Sep 29, 2011 at 11:46 AM, Kukjin Kim <kgene.kim@samsung.com>
wrote:
> > santosh wrote:
> >>
> >> Hi
> >>
> >>  http://kernel.org/
> >>
> >> When I try to browse the above site, it shows "Down for maintenance".
> >> If it is down then from where I can download kernel source ??
> >>
> >
> > You can get it from following:
> >  git://github.com/torvalds/linux.git
> >
> > Thanks.
> >
> > Best regards,
> > Kgene.
> > --
> > Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
> > SW Solution Development Team, Samsung Electronics Co., Ltd.
> >
> >

