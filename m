Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab1C2Aw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 20:52:29 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:59635 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab1C2Aw2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 20:52:28 -0400
Date: Mon, 28 Mar 2011 17:52:23 -0700
From: Andres Salomon <dilinger@queued.net>
To: Fabio Estevam <festevam@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Amit Kucheria <amit.kucheria@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH resend] ARM: mx51_efika: fix build error due to new mfd
 changes
Message-ID: <20110328175223.52c86c0f@queued.net>
In-Reply-To: <AANLkTikLK+jbVhnrNVinhLDXZoozH-6VsjwjYLNwTdxU@mail.gmail.com>
References: <20110328172230.01756522@queued.net>
	<AANLkTikLK+jbVhnrNVinhLDXZoozH-6VsjwjYLNwTdxU@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 21:47:58 -0300
Fabio Estevam <festevam@gmail.com> wrote:

> Andres,
> 
> On Mon, Mar 28, 2011 at 9:22 PM, Andres Salomon <dilinger@queued.net>
> wrote:
> >
> > MFD changes in 4ec1b54c ('mfd: mfd_cell is now implicitly available
> > to mc13xxx drivers') changed the mc13xxx_platform_data struct
> > layout. At the time all users were changed, but this driver was
> > introduced in another tree at the same time.  This updates the
> > mc13xxx_platform_data user, fixing a build error.
> >
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> > ---
> >  arch/arm/mach-mx5/mx51_efika.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> Your patch is in Sascha´s tree now:
> http://git.pengutronix.de/?p=imx/linux-2.6.git;a=commitdiff;h=251290a6078cb88382344b3ee535ae8c6254c1b5
> 
> Regards,
> 
> Fabio Estevam

Ah, thanks, I hadn't heard anything about it.  Linus, feel free to
ignore my patch.
