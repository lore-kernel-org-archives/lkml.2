Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab0LBOwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 09:52:36 -0500
Received: from ist.d-labs.de ([213.239.218.44]:43997 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757470Ab0LBOwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 09:52:34 -0500
Date: Thu, 2 Dec 2010 15:51:41 +0100
From: Florian Mickler <florian@mickler.org>
To: Tobias Karnat <tobias.karnat@googlemail.com>
Newsgroups: gmane.linux.kernel
Cc: Borislav Petkov <bp@alien8.de>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: edac_core: crashes on shutdown
Message-ID: <20101202155141.47d04abc@schatten.dmk.lab>
In-Reply-To: <1291280613.10626.22.camel@Tobias-Karnat>
References: <1291201307.3029.21.camel@Tobias-Karnat>
	<20101201123921.GA15530@a1.tnic>
	<1291209888.12511.11.camel@Tobias-Karnat>
	<20101201143329.GB18074@a1.tnic>
	<1291225614.8646.4.camel@Tobias-Karnat>
	<20101201193508.GA4916@liondog.tnic>
	<1291280613.10626.22.camel@Tobias-Karnat>
X-Newsreader: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Dec 2010 10:03:33 +0100
Tobias Karnat <tobias.karnat@googlemail.com> wrote:

> Am Mittwoch, den 01.12.2010, 20:35 +0100 schrieb Borislav Petkov:
> > Hmm, I see two backtraces now. I'm still not sure whether the first
> > one is actually the first one that happens since it is cut off at the
> > beginning.
> > 
> > If it is the first one, it should contain something like
> > 
> > [ ... ] Pid: ... , comm: ... Not tainted <kernel version> <DMI system name>
> > 
> > the important part being the "Not tainted" string. Can you check that
> > please?
> 
> I only can get an oops with the end cut off or two oopses with the
> beginning cut off.
> 
> But here is an oops with the "Not tainted" string:
> 
> http://oi52.tinypic.com/21nqwky.jpg
> 
> > Also, can you disable the EDAC subsystem in Kconfig and retry?
> > I'm trying to rule out some other issue since the backtraces are
> > inconclusive wrt EDAC.
> > 
> > Thanks.
> 
> Yes, maybe on the weekend, but as I said replacing the modules with
> compiled from older src does work fine.
> 
> -Tobias
> 

What edac modules are you using? 

Regards,
Flo
