Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660Ab2KFCML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 21:12:11 -0500
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57299 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933504Ab2KFCMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 21:12:08 -0500
Date: Tue, 6 Nov 2012 03:12:00 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Heinz Wiesinger <HMWiesinger@gmx.at>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Stultz <john.stultz@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Janne Boman <janne.m.boman@gmail.com>, rtc-linux@googlegroups.com
Subject: Re: [regression] Re: [ 049/149] rtc: Disable the alarm in the
 hardware (v2)
Message-ID: <20121106021200.GC13487@kroah.com>
References: <20120330195823.GA31857@kroah.com>
 <20121105091118.GA12721@elie.Belkin>
 <20121105101331.GA24688@kroah.com>
 <1672482.cmtUloFutg@callisto>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1672482.cmtUloFutg@callisto>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 11:55:32PM +0100, Heinz Wiesinger wrote:
> On Monday 05 November 2012 11:13:31 Greg KH wrote:
> > On Mon, Nov 05, 2012 at 01:11:18AM -0800, Jonathan Nieder wrote:
> > > Hi,
> > > 
> > > In March, Greg KH wrote:
> > > > 3.2-stable review patch.  If anyone has any objections, please let me
> > > > know.
> > > 
> > > Sorry, I'm a little late.  This seems to be causing spurious wakeups
> > > after shutdown on some systems just like v1 did. :/
> > > 
> > > Janne Boman reports[1], using an HP EliteBook 8530w:
> > > | I'm unable to shutdown my system via normal means. The system
> > > | completes the shutdown process, all hardware lights are off, but then
> > > | somehow it restarts.
> > > 
> > > Based on a quick web search, Heinz Wiesinger, using the same model,
> > > 
> > > ran into the same problem and bisected it to this patch:
> > >   https://bugzilla.kernel.org/show_bug.cgi?id=44261
> > > 
> > > Janne confirmed the same by testing kernels closely based on 3.2.13
> > > and 3.2.14 --- 3.2.13 shut down fine, while on 3.2.14 "shutdown -h
> > > now" behaved roughly speaking like "reboot".  A kernel close to 3.6.4
> > > was also affected.
> > 
> > So is 3.6.6 still and issue?  How about 3.7-rc4?  3.4.18?  Figuring out
> > if this is still an issue in Linus's tree would be the best thing to do
> > first.
> 
> I checked 3.7-rc4 and the issue is still there. Should I still test the other 
> versions as well? I can do so but it might take a bit.

No, that should be good enough, this needs to be fixed there first.

> If you need anything else, I'll be happy to help wherever I can.

Working with the developers involved would be great.  Anyone have any
patches that Heinz could test?

thanks,

greg k-h
