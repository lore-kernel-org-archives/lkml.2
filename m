Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab0FOO63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 10:58:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51708 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751458Ab0FOO61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 10:58:27 -0400
Date: Tue, 15 Jun 2010 16:01:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Alan <alan@clueserver.org>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Question on siig sata 3 controller
Message-ID: <20100615160137.62c92494@lxorguk.ukuu.org.uk>
In-Reply-To: <20100615145342.GC26989@bitwizard.nl>
References: <34979.10.6.6.23.1276144792.squirrel@10.6.6.2>
	<4C10A81F.50801@garzik.org>
	<54318.10.6.6.23.1276222123.squirrel@10.6.6.2>
	<20100615065714.GA9034@bitwizard.nl>
	<20100615110748.4303a106@lxorguk.ukuu.org.uk>
	<20100615145342.GC26989@bitwizard.nl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is one of these modules the driver for this controller? I think it's
> AHCI: lshw says it uses ports cc00 ... and a bunch of others, and
> those ports are claimed by ahci according to /proc/ioports. Ah! I need
> better eyes. lshw already mentions that it's ahci...

AHCI will be driving it.
