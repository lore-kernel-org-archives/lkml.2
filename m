Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab2GIV7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:59:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38205 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab2GIV7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:59:41 -0400
Date: Mon, 9 Jul 2012 14:59:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [RESEND AGAIN][PATCH] pcmcia: move unbind/rebind into
 dev_pm_ops.complete
Message-Id: <20120709145939.80537e0e.akpm@linux-foundation.org>
In-Reply-To: <20120706213016.GA15424@kroah.com>
References: <201207062323.52785.chunkeey@googlemail.com>
	<20120706213016.GA15424@kroah.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2012 14:30:16 -0700
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Jul 06, 2012 at 11:23:52PM +0200, Christian Lamparter wrote:
> > The idea of moving rebind procedure into pm.complete
> > was taken from the usb-subsystem, which has similar
> > problems with reattaching devices during/after
> > resume.
> > 
> > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> > ---
> > To Greg:
> > 
> > I have submitted this patch back in March and again in May.
> > As far as I can tell it was neither rejected nor was it
> > accepted into linux-pcmcia.git since. So I'm asking you,
> > if you could take the patch instead... please.
> 
> There is a PCMCIA "team" who should be taking these types of patches.
> Why are they not doing so?
> 

Things are pretty quiet in pcmcia world, but Dominik does appear to
still be doing stuff.

I sometimes queue PCMCIA patches for people, but not this one.  The
changelog is just junk.  What does the patch do?  Why does it do it? 
What problems does it solve?  What are these mysterious "problems with
reattaching devices" to which it refers?  Useless...


