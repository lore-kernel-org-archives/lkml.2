Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab0KPTme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:42:34 -0500
Received: from kroah.org ([198.145.64.141]:51806 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757720Ab0KPTmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:42:07 -0500
Date: Tue, 16 Nov 2010 11:36:46 -0800
From: Greg KH <greg@kroah.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: ft1000: Remove unused char dev inerface.
Message-ID: <20101116193646.GB12492@kroah.com>
References: <1289384128-19823-1-git-send-email-marek.belisko@gmail.com>
 <1289384128-19823-2-git-send-email-marek.belisko@gmail.com>
 <20101111002651.GA21632@kroah.com>
 <AANLkTimteY1P_gU5+ArA8xg3FzS0m9kdQygXSptvhGuh@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimteY1P_gU5+ArA8xg3FzS0m9kdQygXSptvhGuh@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 08:05:40PM +0100, Belisko Marek wrote:
> Hi Greg,
> 
> On Thu, Nov 11, 2010 at 1:26 AM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Nov 10, 2010 at 11:15:27AM +0100, Marek Belisko wrote:
> >> This patch remove lot of code for character device. This
> >> interface was used for getting network informations and
> >> statistics which is currently exported via /proc filesystem.
> >>
> >> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
> >
> > This patch does not apply :(
> I'm trying to resend but need to wait till linux-next will sync with
> linus kernel.
> In mainline there is a patch (61241d97db02559bd83d21ffa783ab327945b925) which
> is not in linux-next.
> 
> I try to apply patch for mainline but it failed. I'll fix and resend then.
> Hopefully this is correct if not forgive me ;)

Everything should be synced up now, please resync and resend.

thanks,

greg k-h
