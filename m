Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751106Ab1EJSkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 14:40:09 -0400
Received: from kroah.org ([198.145.64.141]:39480 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab1EJSkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 14:40:08 -0400
Date: Tue, 10 May 2011 11:35:40 -0700
From: Greg KH <greg@kroah.com>
To: Erik Slagter <erik@slagter.name>
Cc: linux-kernel@vger.kernel.org, Maxin John <maxin.john@gmail.com>
Subject: Re: OOPS after connection Droids MuIn USB display
Message-ID: <20110510183540.GA616@kroah.com>
References: <4DC3B0E3.7010008@slagter.name>
 <4DC3D296.9060707@slagter.name>
 <BANLkTimcWN3=qvurDzyMUs8f5+uFPNumaw@mail.gmail.com>
 <4DC42897.3000300@slagter.name>
 <BANLkTinGydyuG58zwVG43VnDz845BOw1Tg@mail.gmail.com>
 <4DC4EE99.1090205@slagter.name>
 <20110507200252.GA19753@kroah.com>
 <4DC9832E.3040909@slagter.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC9832E.3040909@slagter.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 08:25:50PM +0200, Erik Slagter wrote:
> On 07-05-11 22:02, Greg KH wrote:
> >On Sat, May 07, 2011 at 09:02:49AM +0200, Erik Slagter wrote:
> >>>Congratulations and thanks for explaining the details.
> >>And now my big question is, can this be fixed upstream? ;-)
> >Yes, if someone sends us a patch :)
> 
> Hi Greg,
> 
> Maxin John has been so kind as to make a patch which I tested and
> tweaked a tiny bit. The attached patch set should do the trick. Does
> this suffice this way?

It's a great start, yes.  But could you take a look at the file,
Documentation/Submitting patches and resend it in the format described
there so that I could apply it?

Hint, you need a good description of what the patch does, a
signed-off-by: line, perhaps a tested-by line, and the patch at the
correct level so it can be applied from the root of the kernel tree.

Can you try doing this?

thanks,

greg k-h
