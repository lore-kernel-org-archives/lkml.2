Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab0FORZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:25:35 -0400
Received: from clueserver.org ([65.102.45.174]:37262 "EHLO clueserver.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab0FORZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:25:34 -0400
Subject: Re: Question on siig sata 3 controller
From: Alan <alan@clueserver.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rogier Wolff <R.E.Wolff@BitWizard.nl>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100615160137.62c92494@lxorguk.ukuu.org.uk>
References: <34979.10.6.6.23.1276144792.squirrel@10.6.6.2>
	 <4C10A81F.50801@garzik.org> <54318.10.6.6.23.1276222123.squirrel@10.6.6.2>
	 <20100615065714.GA9034@bitwizard.nl>
	 <20100615110748.4303a106@lxorguk.ukuu.org.uk>
	 <20100615145342.GC26989@bitwizard.nl>
	 <20100615160137.62c92494@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 10:25:32 -0700
Message-ID: <1276622732.6843.2.camel@zowie.clueserver.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-8.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 16:01 +0100, Alan Cox wrote: 
> > Is one of these modules the driver for this controller? I think it's
> > AHCI: lshw says it uses ports cc00 ... and a bunch of others, and
> > those ports are claimed by ahci according to /proc/ioports. Ah! I need
> > better eyes. lshw already mentions that it's ahci...
> 
> AHCI will be driving it.

I have seen this problem with the 2.6.33 kernel in Fedora 13. The
problem goes away in 2.6.35-rc3. (Though networking is fubared for me on
that kernel, so I have not migrated to it.)

My understanding is the "fix" in the driver was to blacklist ncq for
that controller. I have not verified that yet.

