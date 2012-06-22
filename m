Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760919Ab2FVBlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 21:41:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64222 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab2FVBlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 21:41:03 -0400
Date: Thu, 21 Jun 2012 18:40:58 -0700
From: "'Greg KH'" <gregkh@linuxfoundation.org>
To: Alexis Cortes <alexis.cortes@ti.com>
Cc: "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Quach, Brian'" <brian.quach@ti.com>,
        "'Llamas, Jorge'" <jorge.llamas@ti.com>
Subject: Re: [PATCH] usb: host: xhci: Compliance Mode port recovery
Message-ID: <20120622014058.GA3220@kroah.com>
References: <002801cd4e68$a4b4f3a0$ee1edae0$@cortes@ti.com>
 <20120619223928.GD21104@xanatos>
 <004101cd4f33$755e8eb0$601bac10$@cortes@ti.com>
 <20120621000734.GB32743@xanatos>
 <20120621003232.GD3255@kroah.com>
 <4fe35a44.82143c0a.4e83.62a8SMTPIN_ADDED@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fe35a44.82143c0a.4e83.62a8SMTPIN_ADDED@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Thu, Jun 21, 2012 at 12:31:12PM -0500, Alexis Cortes wrote:
> As Sarah proposed, we certainly can apply this patch as a module parameter
> disabled by default and let know our clients that we know are using this
> re-driver to enable the feature to avoid the issue.

Who is a "client"?  And who is going to modify the installer of their
distro in order to automatically enable this option?

That's the problem with options, you never know if you need to turn it
on or not, so I _really_ don't ever want to add any more, the kernel
should "just know" if it needs to be enabled or not.  Surely there is
some way for the kernel to determine if this is your code/hardware
running on the platform or not, right?  No signature in the system
anywhere?  PCI id? DMI table?  ACPI table?  BIOS signature?  Something
else?

You really don't want to be responsible for dealing with 10+ distros in
telling them when they should, or should not, enable this option.  So
please don't create it in the first place.

greg k-h
