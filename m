Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1AFUwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:52:32 -0500
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:38369
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752489Ab1AFUwb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:52:31 -0500
Subject: Re: Using s3virge card in Sun Blade 2000
From: Alex Buell <alex.buell@munted.org.uk>
Reply-To: alex.buell@munted.org.uk
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: David Miller <davem@davemloft.net>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110106204240.GA6361@electric-eye.fr.zoreil.com>
References: <1294086801.17576.14.camel@lithium>
	 <20110103.123939.02282416.davem@davemloft.net>
	 <1294090573.17576.16.camel@lithium>
	 <20110105.110705.104043006.davem@davemloft.net>
	 <1294262022.24378.2.camel@lithium> <1294274029.24378.11.camel@lithium>
	 <20110106204240.GA6361@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: One very high maintenance cat for company
Date: Thu, 06 Jan 2011 20:50:36 +0000
Message-ID: <1294347036.24378.13.camel@lithium>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-Gradwell-MongoId: 4d262b8d.796d-6a04-2
X-Gradwell-Auth-Method: mailbox
X-Gradwell-Auth-Credentials: postmaster@pop3.munted.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 21:42 +0100, Francois Romieu wrote:
> Alex Buell <alex.buell@munted.org.uk> :
> [...]
> > The above code seems to work, and crashes after this point:
> > 
> >       /* Identify chip type */
> >         par->chip = id->driver_data & CHIP_MASK;
> >         par->rev = vga_rcrt(par->vga_iobase, 0x2f);
> >         if (par->chip & CHIP_UNDECIDED_FLAG)
> >                 par->chip = s3_identification(par->chip);
>                                                 ^^^^^^^^^ ?
> Sorry for the obvious but you modified s3_identification() so that it
> stops emitting vga_rcrt(NULL, ...), right ? 

I must have missed that one - thank you for pointing that one out to me!

Regards
Alex
-- 
Tactical Nuclear Kittens
