Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409Ab2KEW5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 17:57:07 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:37370 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751749Ab2KEW5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 17:57:05 -0500
X-Authenticated: #2269360
X-Provags-ID: V01U2FsdGVkX1+S2t8cADOSRrz4EZ4oWLGmA6pbDetR6f/kblXM/y
	fuqIXpas2cx7+9
From: Heinz Wiesinger <HMWiesinger@gmx.at>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Stultz <john.stultz@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Janne Boman <janne.m.boman@gmail.com>, rtc-linux@googlegroups.com
Subject: Re: [regression] Re: [ 049/149] rtc: Disable the alarm in the hardware (v2)
Date: Mon, 05 Nov 2012 23:55:32 +0100
Message-ID: <1672482.cmtUloFutg@callisto>
User-Agent: KMail/4.9.2 (Linux/3.2.32; KDE/4.9.2; x86_64; ; )
In-Reply-To: <20121105101331.GA24688@kroah.com>
References: <20120330195823.GA31857@kroah.com> <20121105091118.GA12721@elie.Belkin> <20121105101331.GA24688@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 November 2012 11:13:31 Greg KH wrote:
> On Mon, Nov 05, 2012 at 01:11:18AM -0800, Jonathan Nieder wrote:
> > Hi,
> > 
> > In March, Greg KH wrote:
> > > 3.2-stable review patch.  If anyone has any objections, please let me
> > > know.
> > 
> > Sorry, I'm a little late.  This seems to be causing spurious wakeups
> > after shutdown on some systems just like v1 did. :/
> > 
> > Janne Boman reports[1], using an HP EliteBook 8530w:
> > | I'm unable to shutdown my system via normal means. The system
> > | completes the shutdown process, all hardware lights are off, but then
> > | somehow it restarts.
> > 
> > Based on a quick web search, Heinz Wiesinger, using the same model,
> > 
> > ran into the same problem and bisected it to this patch:
> >   https://bugzilla.kernel.org/show_bug.cgi?id=44261
> > 
> > Janne confirmed the same by testing kernels closely based on 3.2.13
> > and 3.2.14 --- 3.2.13 shut down fine, while on 3.2.14 "shutdown -h
> > now" behaved roughly speaking like "reboot".  A kernel close to 3.6.4
> > was also affected.
> 
> So is 3.6.6 still and issue?  How about 3.7-rc4?  3.4.18?  Figuring out
> if this is still an issue in Linus's tree would be the best thing to do
> first.

I checked 3.7-rc4 and the issue is still there. Should I still test the other 
versions as well? I can do so but it might take a bit.

If you need anything else, I'll be happy to help wherever I can.

Grs,
Heinz
