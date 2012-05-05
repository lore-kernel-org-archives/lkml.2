Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760772Ab2EEAfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 20:35:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41709 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723Ab2EEAfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 20:35:51 -0400
Date: Fri, 4 May 2012 17:35:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Francois Rigaut <frigaut@gmail.com>
Cc: linux-pci@vger.kernel.org,
        Nico Schottelius <nico-linux-20120419@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux Support for Thunderbolt using Apple Monitor
Message-ID: <20120505003547.GA14166@kroah.com>
References: <20120502163629.GE928@schottelius.org>
 <20120502202509.GA26798@kroah.com>
 <20120503065003.GB13386@schottelius.org>
 <CAMVeQ8qYu4bShd_+pwRv8bShhusJMDa-jjoqu7EujS4jt7RSNA@mail.gmail.com>
 <20120503153547.GD20334@kroah.com>
 <CAMVeQ8q3PMMGmFSgrnqbW2HVdfmN+LgatX3TSfv5_2Ebuuj=QQ@mail.gmail.com>
 <20120503233858.GA13453@kroah.com>
 <4FA358ED.1080705@gmail.com>
 <20120504184851.GB11223@kroah.com>
 <4FA47443.9040505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA47443.9040505@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 10:28:51AM +1000, Francois Rigaut wrote:
> 
> 
> On 05/05/12 04:48, Greg KH wrote:
> >Oh, what exact machine is this? Maybe I can ask around and see if
> >I can dig up one myself, and hey, I always need an excuse to get a
> >new display :) thanks, greg k-h
> The machine is a macbook air 13" mid 2011, with a thunderbolt port
> (physically identical to a mini display port). I hear Linus is using
> a MBA 11", so I don't feel alone here running linux on this thing.
> The display is a 27" Apple thunderbolt display. It's a gorgeous
> display with deep colors and lots of dynamics, and not (much) more
> expensive than other 27" display. But it doesn't hot plug (in linux,
> yet) and the only input is through the thunderbolt cable so no luck
> in using alternatives like HDMI (neither VGA, but VGA doesn't
> support the display resolution 2560x1440 anyway).

Has anyone tried a Thunderbolt hard drive yet?  Not that I think that
would work better, just curious.

Thanks for the device type, I'll see if I can track one down...

greg k-h
