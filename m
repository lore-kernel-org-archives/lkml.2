Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab0KTBmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 20:42:17 -0500
Received: from kroah.org ([198.145.64.141]:34192 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab0KTBmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 20:42:15 -0500
Date: Fri, 19 Nov 2010 17:16:45 -0800
From: Greg KH <greg@kroah.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: ft1000: Remove unused char dev inerface.
Message-ID: <20101120011645.GB29633@kroah.com>
References: <1289384128-19823-1-git-send-email-marek.belisko@gmail.com>
 <1289384128-19823-2-git-send-email-marek.belisko@gmail.com>
 <20101111002651.GA21632@kroah.com>
 <AANLkTimteY1P_gU5+ArA8xg3FzS0m9kdQygXSptvhGuh@mail.gmail.com>
 <20101116193646.GB12492@kroah.com>
 <AANLkTinEvAXRGdgoWfzRx3Q8xSfkuTLhn21AoV3iz0ih@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinEvAXRGdgoWfzRx3Q8xSfkuTLhn21AoV3iz0ih@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 09:43:00AM +0100, Belisko Marek wrote:
> Hi Greg,
> 
> On Tue, Nov 16, 2010 at 8:36 PM, Greg KH <greg@kroah.com> wrote:
> > On Sat, Nov 13, 2010 at 08:05:40PM +0100, Belisko Marek wrote:
> >> Hi Greg,
> >>
> >> On Thu, Nov 11, 2010 at 1:26 AM, Greg KH <greg@kroah.com> wrote:
> >> > On Wed, Nov 10, 2010 at 11:15:27AM +0100, Marek Belisko wrote:
> >> >> This patch remove lot of code for character device. This
> >> >> interface was used for getting network informations and
> >> >> statistics which is currently exported via /proc filesystem.
> >> >>
> >> >> Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
> >> >
> >> > This patch does not apply :(
> >> I'm trying to resend but need to wait till linux-next will sync with
> >> linus kernel.
> >> In mainline there is a patch (61241d97db02559bd83d21ffa783ab327945b925) which
> >> is not in linux-next.
> >>
> >> I try to apply patch for mainline but it failed. I'll fix and resend then.
> >> Hopefully this is correct if not forgive me ;)
> >
> > Everything should be synced up now, please resync and resend.
> I'll change my mind and from this patch series I'll resend just 1/3 patch.
> Patch 2/3 (followed by 3/3) is maybe not correct because it completely
> remove access to
> device from user space through /dev interface (used for debugging and testing).
> 
> My first idea was just remove it completely because we have a device which just
> connect to network and don't need to have some debug interface.

Yes, that sounds correct.  Use debugfs if you need/want a debug
interface to the driver.

thanks,

greg k-h
