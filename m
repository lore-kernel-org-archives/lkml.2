Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1D0CCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 22:02:36 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:56111 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756447Ab1D0CCe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 22:02:34 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <pefoley2@verizon.net>,
        "=?ISO-8859-1?Q?'Am=E9rico_Wang'?=" <xiyou.wangcong@gmail.com>,
        "Sam Ravnborg" <sam@ravnborg.org>
Cc: "'Arnaud Lacombe'" <lacombar@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mmarek@suse.cz>
References: <4DB4AEF7.3090607@verizon.net>	<BANLkTi=K3OEumicFMCT_Dh=xhpzfpa3JBw@mail.gmail.com> <BANLkTikFUhiDSEM_yLtbzmhfdUWBDv71ww@mail.gmail.com> <4DB73357.5020403@verizon.net>
In-Reply-To: <4DB73357.5020403@verizon.net>
Subject: RE: [PATCH] kbuild: mark unicore32 header export as broken
Date: Wed, 27 Apr 2011 10:02:01 +0800
Message-ID: <009f01cc047f$1b20bdb0$51623910$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQG7in9qt1Kz4Qu/szr3STkj03XELQEVt+D2Ap3JWLUCLEG2XZRi6YZQ
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Peter Foley [mailto:pefoley2@verizon.net]
> Sent: Wednesday, April 27, 2011 5:04 AM
> To: Américo Wang
> Cc: Arnaud Lacombe; linux-kernel@vger.kernel.org; linux-kbuild@vger.kernel.org; mmarek@suse.cz; gxt@mprc.pku.edu.cn
> Subject: Re: [PATCH] kbuild: mark unicore32 header export as broken
> 
> On 4/26/2011 1:07 PM, Américo Wang wrote:
> > On Tue, Apr 26, 2011 at 2:48 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> >> Hi,
> >>
> >> On Sun, Apr 24, 2011 at 7:15 PM, Peter Foley <pefoley2@verizon.net> wrote:
> >>> This patch marks userspace header export for unicore32 as broken so that
> >>> it is skipped when running make headers_install_all.
> >>>
> >> Why ?
> >>
> >> I would expect you to send this to arch/unicore32 maintainer too, he
> >> is not in the CC: list.
> >
> > +1
> >
> > If you see errors when install kernel headers on unicore32, fix them instead
> > of marking it as broken.
> 
> The problem with unicore32 is that it generates various stub headers at compile time in include/generated/asm.
> I believe the unicore32 maintainer is already aware of headers_install not working (see https://lkml.org/lkml/2011/1/8/11).
Yes, thanks.
I am waiting for the generic-y patch by Sam. (also CC to Sam)
Sorry to broke the rule of headers_install_all.

Thanks Peter. The patch not applied since I do need headers_install.

Thanks & Regards,

Guan Xuetao

