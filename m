Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab1JYRnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 13:43:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48918 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab1JYRnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 13:43:45 -0400
Date: Tue, 25 Oct 2011 18:42:22 +0100
From: Mark Einon <mark.einon@gmail.com>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Mark Einon <mark.einon@gmail.com>, Greg KH <greg@kroah.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH staging 6/6] et131x: uncloak PCIe capabilities.
Message-ID: <20111025174149.GA4251@msilap.einon>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com>
 <20111023093651.GA22285@kroah.com>
 <20111023094231.GA3409@msilap.einon>
 <20111023171214.GF28657@electric-eye.fr.zoreil.com>
 <20111024195602.GA3473@msilap.einon>
 <20111025155921.GC2019@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025155921.GC2019@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 05:59:21PM +0200, Francois Romieu wrote:
> Mark Einon <mark.einon@gmail.com> :
> [...]
> > The PCIe changes are good, however I think using gotos here doesn't add
> > anything as there's no difficult locking to navigate and makes the code
> > harder to read.
> > both out: and err_out: are used to return an error, and the backwards
> > jumping goto makes me a bit uncomfortable. Could you respin with just the
> > PCIe changes?
> 
> I confess I use a 55 lines vi split terminal when reviewing these blocks.
> 
> As there is no documentation to check the remaining PCIe candidate bits,
> it's probably not worth it anyway.

Ok, I'll fixup the changes I highlighted and Ack your original patches, it's not much work to do so.

I do have some documentation for the PCI part of the registers (et1310_datasheet.pdf), which you can find online or I can send you a copy if you're interested (I managed to get it from LSI, who bought Agere).
I've also been using a datasheet for the truephy ET1011 (also found online) as reference for some of the other registers, which although not exactly the same, is almost identical. You're welcome to a copy of that too.

Cheers,

Mark
