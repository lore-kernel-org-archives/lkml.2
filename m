Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803Ab2IJSTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:19:06 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52237 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab2IJSTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:19:01 -0400
Date: Mon, 10 Sep 2012 11:18:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: Mike Waychison <mikew@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        khalid@gonehiking.org
Subject: Re: [PATCH v2] Add missing attributes to EFI variable attribute
 print out from sysfs
Message-ID: <20120910181855.GA26404@kroah.com>
References: <20120713174216.GA10445@hp.com>
 <CAGTjWtDyGrVuBXZzdDfbS961cRSQY7eZaEbb9E8HACk5-imiuQ@mail.gmail.com>
 <CAGTjWtAPKXfA7pOqWEfK2i_HbrtA6_w7+ezZyCo4NG1gBSEhwg@mail.gmail.com>
 <20120910180335.GA26021@kroah.com>
 <1347300789.4393.27.camel@lyra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347300789.4393.27.camel@lyra>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 12:13:09PM -0600, Khalid Aziz wrote:
> On Mon, 2012-09-10 at 11:03 -0700, Greg KH wrote:
> > On Mon, Sep 10, 2012 at 01:59:18PM -0400, Mike Waychison wrote:
> > > On Mon, Sep 10, 2012 at 1:55 PM, Mike Waychison <mikew@google.com> wrote:
> > > > Greg,
> > > >
> > > > Can you please pick this patch up in one of your trees?
> > > 
> > > Resend using a good email addy for gregkh :)
> > 
> > Can someone resend it in a format that I can apply it in?  I can't find
> > the original anymore, sorry.
> > 
> > greg k-h
> 
> Some of the EFI variable attributes are missing from print out from
> /sys/firmware/efi/vars/*/attributes. This patch adds those in. It also
> updates code to use pre-defined constants for masking current value
> of attributes.
> 
> Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 47408e8..d10c987 100644

This isn't in a format I can apply it in, without having to edit the
heck out of the email by hand :(

Care to try it again, adding the different acks it picked up along the
review way, and send it, again as I asked for, in a format I can apply
it in?

greg k-h
