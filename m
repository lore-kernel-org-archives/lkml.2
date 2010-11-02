Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab0KBOHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 10:07:03 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49473 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753177Ab0KBOG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:06:57 -0400
Date: Tue, 2 Nov 2010 14:06:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Naveen Kumar G <naveen.gaddipati@stericsson.com>,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com
Subject: Re: [PATCHv1] staging: Synaptics RMI4 touchpad driver support
Message-ID: <20101102140611.59d40e25@lxorguk.ukuu.org.uk>
In-Reply-To: <20101102140337.GC9387@kroah.com>
References: <1288699725-14405-1-git-send-email-naveen.gaddipati@stericsson.com>
	<20101102140337.GC9387@kroah.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Nov 2010 07:03:37 -0700
Greg KH <greg@kroah.com> wrote:

> On Tue, Nov 02, 2010 at 05:38:45PM +0530, Naveen Kumar G wrote:
> > --- /dev/null
> > +++ b/drivers/staging/ste_rmi4/TODO
> > @@ -0,0 +1,7 @@
> > +TODO
> > +----
> > +
> > +Wait for the official upstream synaptics rmi4 clearpad drivers as promised over the past few months
> > +Merge any device support needed from this driver into it
> > +Delete this driver
> 
> Huh?
> 
> Why not just add this driver to the kernel tree instead?  When the
> "promised" driver then eventually shows up (who is promising it?) then
> delete the thing.

I've suggested that in the past.

> But until then, why is this needed to go into the staging tree?  Is
> there any other main reason it should be here and not in the "real" part
> of the kernel?

It's a driver nobody wants to commit to keeping around when there is
eventually a general purpose driver. In other words things like module
names will change.
