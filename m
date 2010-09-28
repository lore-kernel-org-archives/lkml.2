Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab0I1GfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 02:35:13 -0400
Received: from ist.d-labs.de ([213.239.218.44]:53378 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488Ab0I1GfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 02:35:09 -0400
Date: Tue, 28 Sep 2010 08:35:05 +0200
From: Florian Mickler <florian@mickler.org>
To: tmhikaru@gmail.com
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.35.6
Message-ID: <20100928083505.0a808ffd@schatten.dmk.lab>
In-Reply-To: <20100927233956.GA15705@roll>
References: <20100927003608.GA20395@kroah.com>
	<20100927163208.GA4892@roll>
	<20100927215135.3d11d587@schatten.dmk.lab>
	<20100927233956.GA15705@roll>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010 19:39:56 -0400
tmhikaru@gmail.com wrote:

> On Mon, Sep 27, 2010 at 09:51:35PM +0200, Florian Mickler wrote:
> > I can't comment on the bouncing part, but increased load average is
> > partly bisected down in Bug 16525 (unexpected high load since 2.6.35
> > Bug 16525)[1]. Maybe you are seeing something similiar? 
> 
> If you're referring to
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=16525
> 

> then I have to admit that's very interesting; in fact, I tested my machine
> without X running, and the problem I'm having goes away entirely - loadavg
> quickly settles to 0.00 - and even with *only* a mrxvt terminal running,
> that is to say NO window manager, just mrxvt running, X on 2.6.35.3 and
> later has the wildly bouncy load averages.

That would of course lead one to think it happens
somewhere in the gfx stack. 

> 
> Here's a graphical example of just how wacky this is:
> 
> http://yfrog.com/6lloadbp
> 
> In this image, the dip down to less than 0.5 after the 18'th is due to me
> experimenting using the slackware distribution kernel (2.6.33.4) after I
> finally noticed something was amiss. The sharp rise afterwards is due to me
> first, building 2.6.35.5, and then afterwards, using it. To be perfectly
> clear, I've previously used 2.6.34.2 and did not experience the problem
> there either, nor is it in 2.6.33.4.

What load figure are you basing your observations on? The 15 minutes
average should be the most interesting (sampled at a 7 minutes
interval...)

Regards,
Flo 
