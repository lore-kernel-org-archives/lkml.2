Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab1BKSmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:42:50 -0500
Received: from kroah.org ([198.145.64.141]:35615 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab1BKSmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:42:47 -0500
Date: Fri, 11 Feb 2011 10:32:45 -0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Tim Hockin <thockin@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Robert Lippert <rlippert@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: SMBIOS / DMI Event Logs in Linux?
Message-ID: <20110211183245.GA10891@kroah.com>
References: <4D547236.6080702@google.com>
 <20110211012552.GA28995@kroah.com>
 <AANLkTi=tbYj_bonu2i+NHpNY3KUMpsTVT8YDsLhDz_Nm@mail.gmail.com>
 <20110211032049.GB884@kroah.com>
 <AANLkTin3tu-NiotpzWaQ_ubV0jumb_WsjEK5QGi5w56o@mail.gmail.com>
 <AANLkTi=Umq5gPr4xT4iChm+B+C+TOF1SB8gC4_ygqztR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=Umq5gPr4xT4iChm+B+C+TOF1SB8gC4_ygqztR@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 10:00:37AM -0800, Mike Waychison wrote:
> resend as plain text, sorry :(
> 
> 
> On Thu, Feb 10, 2011 at 7:20 PM, Greg KH <greg@kroah.com> wrote:
> > Wait, if this is just a simple "pass through to the hardware", then just
> > export the thing, with the proper permissions, in a single binary sysfs
> > file, and do the parsing in userspace.
> >
> 
> If you mean s/hardware/firmware/, then yes.

Yes, sorry, that is what I ment.

> > That would be the simplest thing to do, and fit the rules for valid
> > sysfs files, and keep people from having to dig through /dev/mem, right?
> 
> Yup, exposing the log via a bin_attribute and allowing for blobs to be
> appended (with the firmware either accepting or rejecting the format
> will do).

Great, that should be a simple thing to do then, right?

greg k-h
