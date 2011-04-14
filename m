Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1DNVzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:55:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:54643 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab1DNVzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:55:16 -0400
Subject: Re: [regression] 2.6.39-rc[1-3] fail to boot on G5 PowerMac
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hughd@google.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Jens Axboe <jaxboe@fusionio.com>,
        kevin diggs <diggskevin38@gmail.com>,
        Michel Daenzer <michel@daenzer.net>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTimykvKp=bwsFyNE9fWqcE9Ffws6bA@mail.gmail.com>
References: <19876.35918.322649.256455@pilspetsen.it.uu.se>
	 <1302646173.28876.53.camel@pasglop> <1302652502.28876.76.camel@pasglop>
	 <19877.23529.745123.819112@pilspetsen.it.uu.se>
	 <1302685102.28876.81.camel@pasglop>
	 <BANLkTimc84A8kddarnhvrcab3iKZc0HZAg@mail.gmail.com>
	 <1302736869.28876.91.camel@pasglop>
	 <BANLkTika8FY1dD_hOQ4wMhHzuQ2Qt8fg7A@mail.gmail.com>
	 <1302771756.15520.100.camel@thor.local>
	 <BANLkTimykvKp=bwsFyNE9fWqcE9Ffws6bA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Apr 2011 07:54:49 +1000
Message-ID: <1302818089.28876.134.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 14:25 -0700, Hugh Dickins wrote:
> 
> Something worth trying: turn off CONFIG_IDE.  That's what I need to
> boot 2.6.39-rc[1-3] on PowerPC G5.
> 
> I know Jens has been fixing problems with IDE versus his plug/unplug
> changes, but it's still not fixed for me in rc3.
> 
> In other mail http://lkml.org/lkml/2011/4/14/614
> I see Linus recommending his post-rc3 commit 6631e635c65d
> but I've not tried that myself yet.

Well, the disk is SATA so it's CONFIG_ATA/libata, which works fine here,
unless you somewhat replaced your CD-ROM with a legacy IDE disk :-) Or
maybe the problem is related to the CD-ROM drive. There's a libata
driver for it nowadays, so you can use PATA_MACIO instead of IDE_PMAC

Cheers,
Ben.


