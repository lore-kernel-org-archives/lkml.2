Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0LUR7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 12:59:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:53588 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab0LUR7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 12:59:50 -0500
Date: Tue, 21 Dec 2010 09:58:27 -0800
From: Greg KH <gregkh@suse.de>
To: merez@codeaurora.org
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH v2] usb: Add streams support to epautoconf.
Message-ID: <20101221175827.GA8709@suse.de>
References: <ccc3842ee0be7b1036143d1fccd005a0.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ccc3842ee0be7b1036143d1fccd005a0.squirrel@www.codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 05:46:34AM -0800, merez@codeaurora.org wrote:
> > On Mon, Dec 20, 2010 at 11:58AM, Greg KH wrote:
> > Ok, but please note the word of "proprietary" usually means something 
> else when talking about kernel code (i.e. licensing issues.)
> >
> > I'll be glad to take this type of patch when you also provide a patch
> that uses the callback, but not before then.
> 
> What I meant by "proprietary" is not proprietary in the terms of kernel
> world. I meant a unique algorithm, different from the default. Sorry for
> the misunderstanding.
> Currently we don't have a unique algorithm. When implementing this change
> we thought it may be useful for other controllers but for us the default
> implementation was good enough.

First rule of kernel development, "don't add infrastructure that you do
not need today."

thanks,

greg k-h
