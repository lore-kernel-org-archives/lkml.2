Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2BWQqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:46:30 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56450 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2BWQq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:46:29 -0500
Date: Thu, 23 Feb 2012 08:44:39 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jiri Slaby <jslaby@suse.cz>, stable <stable@kernel.org>, mjg@redhat.com,
        LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
        "jirisl >> Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: Lost ps/2 input in 3.2.5 (aka PCI: Rework ASPM disable code)
Message-ID: <20120223164439.GA10737@kroah.com>
References: <4F4540E6.2020708@suse.cz>
 <20120223083016.58cba319@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223083016.58cba319@jbarnes-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 08:30:16AM -0800, Jesse Barnes wrote:
> On Wed, 22 Feb 2012 20:24:22 +0100
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
> > Hi,
> > 
> > so I finally decided to commit 3.2.5 into the opensuse kernel. However
> > it does not even work on my laptop.
> > 
> > Both keyboard and touchpad are not detected. They are connected via PS/2.
> > 
> > I see
> > PNP: PS/2 appears to have AUX port disabled, if this is incorrect please
> > boot with i8042.nopnp
> > 
> > Without that patch this warning is gone and devices properly enumerated.
> 
> Does it also work if you pass pcie_aspm=off when you boot?

I thought Matthew had a patch queued up for 3.3-final that would fix
this.  Matthew, what happened to that?

greg k-h
