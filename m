Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab1FULQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 07:16:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60211 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755790Ab1FULQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 07:16:33 -0400
Date: Tue, 21 Jun 2011 12:18:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: gma500: Whats needed to add support for 8086:4108
Message-ID: <20110621121851.4285b0c5@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTi=u8MaGWayiW92SV44P5URpOO9TXQ@mail.gmail.com>
References: <BANLkTi=u8MaGWayiW92SV44P5URpOO9TXQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jun 2011 12:50:57 +0200
Christian Gmeiner <christian.gmeiner@gmail.com> wrote:

> Hi community,
> 
> I am trying to get linux with X11 running on a system with a
> 
> VGA compatible controller [0300]: Intel Corporation Atom Processor
> E6xx Integrated Graphics Controller [8086:4108] (rev 03)
> 
> I had a quick look at the gma500 driver, but it does not support this
> device. So whats needed to add support for my device
> in the gma500 driver? I am not sure if I simply can add the my device
> id to the driver without breaking my the graphics controller.

The various GMA500/600 type devices are all pretty similar at the
GTT/memory/PCI layer so the chances are it'll mostly work. How well it
works will depend in detail upon the videout output side of your hardware
platform and how much the E600 differs from Moorestown/Oaktrail. In
particular if you have a MIPI output then it'll need a fair bit of work.

I've not seen any Linux drivers with the non-free userspace for the E600
yet and until those appear there are no kernel bits to work from to drop
into the gma500 driver.

I'd take it up with your board vendor and Intel see what their plans are.

Alan
