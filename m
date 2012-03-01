Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab2CADBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 22:01:02 -0500
Received: from exprod5og115.obsmtp.com ([64.18.0.246]:50038 "HELO
	exprod5og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932442Ab2CADBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 22:01:00 -0500
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Feb 2012 22:01:00 EST
Authentication-Results: mr.google.com; spf=pass (google.com: domain of vhtnguyen@apm.com designates 10.112.84.170 as permitted sender) smtp.mail=vhtnguyen@apm.com
From: Vinh Huu Tuong Nguyen <vhtnguyen@apm.com>
References: <1324385014-30725-1-git-send-email-vhtnguyen@apm.com> <CA+5PVA5SZmeEdBF0XvNmvCwroCKs1EwdWNbd_nwyEDCoZGHo2Q@mail.gmail.com>
In-Reply-To: <CA+5PVA5SZmeEdBF0XvNmvCwroCKs1EwdWNbd_nwyEDCoZGHo2Q@mail.gmail.com>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acz26ahmFLHP7k5QT8ipW85Zuhe2tQAbAlPw
Date: Thu, 1 Mar 2012 09:53:27 +0700
Message-ID: <e2fe6a6317e1ea6e04c34281b74b2277@mail.gmail.com>
Subject: RE: [PATCH 1/3] powerpc/44x: The bug fixed support for APM821xx SoC
 and Bluestone board
To: Josh Boyer <jwboyer@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Josh Boyer [mailto:jwboyer@gmail.com]
> Sent: Wednesday, February 29, 2012 8:54 PM
> To: Vinh Nguyen Huu Tuong
> Cc: Benjamin Herrenschmidt; Paul Mackerras; linuxppc-
> dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/3] powerpc/44x: The bug fixed support for
> APM821xx SoC and Bluestone board
>
> On Tue, Dec 20, 2011 at 7:43 AM, Vinh Nguyen Huu Tuong
> <vhtnguyen@apm.com> wrote:
> > This patch consists of:
> > - Fix the pvr mask for checking pvr in cputable.c
> > - Fix the cpu name as consistent with cpu name is describled in dts
> file
> >
> > Signed-off-by: Vinh Nguyen Huu Tuong <vhtnguyen@apm.com>
> > ---
>
> I was waiting to see if you would submit a new series with patch 3/3
> fixed for
> the comments I made.  Seems you haven't yet or I missed it entirely.
> For now,
> I'll take this patch as it's stand-alone.  The DTS and PCI driver
> patches will
> need to be submitted together again.

I'm sorry for my lateness, I've been ready to submit new update 2 weeks
ago, but when I synced up with master branch again, the version of Linux
is changed (changed to 3.2) with some updates from Marri that made my
update didn't work. I have to update and test again. I'll submit the new
update within this week as your recommendation.

Best regards,
Vinh Nguyen.
