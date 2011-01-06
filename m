Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab1AFUmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:42:55 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:41131 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1AFUmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:42:53 -0500
Date: Thu, 6 Jan 2011 21:42:40 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Alex Buell <alex.buell@munted.org.uk>
Cc: David Miller <davem@davemloft.net>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Using s3virge card in Sun Blade 2000
Message-ID: <20110106204240.GA6361@electric-eye.fr.zoreil.com>
References: <1294086801.17576.14.camel@lithium> <20110103.123939.02282416.davem@davemloft.net> <1294090573.17576.16.camel@lithium> <20110105.110705.104043006.davem@davemloft.net> <1294262022.24378.2.camel@lithium> <1294274029.24378.11.camel@lithium>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294274029.24378.11.camel@lithium>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

Alex Buell <alex.buell@munted.org.uk> :
[...]
> The above code seems to work, and crashes after this point:
> 
>    	/* Identify chip type */
>         par->chip = id->driver_data & CHIP_MASK;
>         par->rev = vga_rcrt(par->vga_iobase, 0x2f);
>         if (par->chip & CHIP_UNDECIDED_FLAG)
>                 par->chip = s3_identification(par->chip);
                                                ^^^^^^^^^ ?
Sorry for the obvious but you modified s3_identification() so that it
stops emitting vga_rcrt(NULL, ...), right ?

-- 
Ueimor
