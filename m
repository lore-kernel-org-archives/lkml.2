Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab1C3CAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:00:34 -0400
Received: from mail.perches.com ([173.55.12.10]:4411 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348Ab1C3CAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:00:32 -0400
Subject: Re: [PATCH 09/23] hdaps: Convert printks to pr_<level>
From: Joe Perches <joe@perches.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, Frank Seidel <frank@f-seidel.de>,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
In-Reply-To: <AANLkTikWbHSPaCTStEz5v=gEvm-nG6MU2eSCq9G8eZtD@mail.gmail.com>
References: <cover.1301436234.git.joe@perches.com>
	 <f4fbd2191533fd96fa59ba19c9917ed679920e1b.1301436234.git.joe@perches.com>
	 <AANLkTikWbHSPaCTStEz5v=gEvm-nG6MU2eSCq9G8eZtD@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 19:00:30 -0700
Message-ID: <1301450430.4113.24.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 22:54 -0300, Lucas De Marchi wrote:
> > diff --git a/drivers/platform/x86/hdaps.c b/drivers/platform/x86/hdaps.c
> > @@ -238,7 +240,7 @@ static int hdaps_device_init(void)
> >                     __check_latch(0x1611, 0x01))
> >                goto out;
> >
> > -       printk(KERN_DEBUG "hdaps: initial latch check good (0x%02x).\n",
> > +       printk(KERN_DEBUG "hdaps: initial latch check good (0x%02x)\n",
> 
> Shouldn't this be pr_debug() or pr_devel() ?

Hi Lucas.

Using pr_debug changes behavior unless
CONFIG_DYNAMIC_DEBUG or #define DEBUG is used.

I prefer not to change those unless there's
agreement.

cheers, Joe

