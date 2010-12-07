Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0LGU0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 15:26:48 -0500
Received: from kroah.org ([198.145.64.141]:36165 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab0LGU0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 15:26:46 -0500
Date: Tue, 7 Dec 2010 12:21:22 -0800
From: Greg KH <greg@kroah.com>
To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.36.1
Message-ID: <20101207202122.GC11264@kroah.com>
References: <20101122191831.GG4340@kroah.com>
 <AANLkTin2Wjfyo+pHBXR97bArS3=sSGmi5DCL8kapavSU@mail.gmail.com>
 <20101122213200.GC2881@suse.de>
 <20101122235549.GA31460@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101122235549.GA31460@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 06:55:50PM -0500, Dave Jones wrote:
> On Mon, Nov 22, 2010 at 01:32:00PM -0800, Greg KH wrote:
>  > On Mon, Nov 22, 2010 at 10:52:26PM +0200, Felipe Contreras wrote:
>  > > On Mon, Nov 22, 2010 at 9:18 PM, Greg KH <gregkh@suse.de> wrote:
>  > > > I'm announcing the release of the 2.6.36.1 kernel.
>  > > >
>  > > > All users of the 2.6.36 kernel series must upgrade.
>  > > >
>  > > > The updated 2.6.36.y git tree can be found at:
>  > > >        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.36.y.git
>  > > > and can be browsed at the normal kernel.org git web browser:
>  > > >        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.36.y.git;a=summary
>  > > >
>  > > > thanks,
>  > > 
>  > > This one is missing
>  > > 0e7adbe ALSA: hda - Disable sticky PCM stream assignment for AD codecs
>  > > 
>  > > Otherwise sound doesn't work on AD codecs.
>  > 
>  > It will get into .2, thanks.

It's now queued up.

> ed3aada1bf34c5a9e98af167f125f8a740fc726a also seems to be missing.
> 
> 63bfd7384b119409685a17d5c58f0b56e5dc03da should be considered too.

These are also queued up.

thanks,

greg k-h
