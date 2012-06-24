Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab2FXGjK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 02:39:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56920 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab2FXGjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 02:39:08 -0400
Date: Sat, 23 Jun 2012 23:39:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: iseletsk@cloudlinux.com
Cc: fa.linux.kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, Matthew Garrett <mjg59@srcf.ucam.org>,
        Alex Lyashkov <umka@cloudlinux.com>
Subject: Re: [PATCH] Taint kernel when lve module is loaded
Message-ID: <20120624063903.GB11266@kroah.com>
References: <fa.WTHIDfGYg3w7zn9rxlDshNfnPtI@ifi.uio.no>
 <b770341d-e1e3-4d57-b283-3d8ff92b0d36@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b770341d-e1e3-4d57-b283-3d8ff92b0d36@googlegroups.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 08:07:12AM -0700, iseletsk@cloudlinux.com wrote:
> Hello Everyone,
> 
> I am very sorry about this situation. It was my oversight. We planned
> to close source the module, and we will do it later on. Yet, it looks
> like one of our developers missed the point -- and did things
> incorrectly.
> 
> Please, give us two-three weeks to straighten things out. By the end
> of three weeks I plan to have source RPMs with the GPLed version of
> the modules available in our source repositories.

As you built the binary from some codebase already, why not just post
the source for this code now?  There should not be any delay needed.

> Later on we will have new module that is not GPL released.

Why?  What is that going to provide to you?  You are aware of how the
Linux kernel community feels about closed source kernel modules, and how
your customers will be the ones dealing with the problems surrounding
that type of decision?

> Once again -- I am sorry about the incident. We haven't planned to
> deceive anyone. This was more of an internal miscommunication then
> anything else.

Understood about the miscommunication, but I don't understand any delay
as you do kind of have to provide the source now that we have asked for
it as per the license you released it to us.

thanks,

greg k-h
