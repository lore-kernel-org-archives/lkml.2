Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab2BWXEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:04:45 -0500
Received: from 1wt.eu ([62.212.114.60]:62592 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab2BWXEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:04:44 -0500
Date: Fri, 24 Feb 2012 00:04:30 +0100
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raphael Prevost <raphael@buro.asia>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
Message-ID: <20120223230430.GE1306@1wt.eu>
References: <20120223204832.GA30322@kroah.com> <4F46A6EC.8050804@zytor.com> <20120223211016.GA16275@kroah.com> <20120223215242.GA1306@1wt.eu> <CA+55aFyxB4kmmSOKDSRkAkaRx=G7o7JnuUGBu3_WVr9KbpWWYQ@mail.gmail.com> <20120223222733.GB1306@1wt.eu> <CA+55aFxztx=Cf8i+jZE=X8Zx1BZnNpC6wv-PkWcXDfBFS6qWqg@mail.gmail.com> <4F46C253.106@zytor.com> <20120223225227.GD1306@1wt.eu> <4F46C3CF.40303@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F46C3CF.40303@zytor.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 02:55:11PM -0800, H. Peter Anvin wrote:
> On 02/23/2012 02:52 PM, Willy Tarreau wrote:
> > On Thu, Feb 23, 2012 at 02:48:51PM -0800, H. Peter Anvin wrote:
> >> On 02/23/2012 02:38 PM, Linus Torvalds wrote:
> >>>
> >>> You'd still need an x86-32 machine to test on, because x86-64 was
> >>> immune to this issue.
> >>>
> >>> But yeah, the impact of this seems to be small enough that for older
> >>> kernels (which are likely used on older systems for maintenance
> >>> anyway) disabling AES-NI on x86-32 really might be the way to go.
> >>>
> >>
> >> That would really suck for users of encrypted hard disks.
> > 
> > Peter, do you really think there are that many ? I think I only saw
> > AES-NI on recent 64-bit capable chips, and it's been a while that
> > users have been installing 64-bit distros on such machines. Note that
> > I'm not advocating for breaking existing setups, just that I'm surprized
> > by this combination (aes-ni + 32-bit).
> > 
> 
> There are still people running 32-bit systems because they have some odd
> compatibility constraints but now have to deal with corporate or other
> security constraints; they may also have been using disk encryption
> since before AES-NI was in but doing it on the integer side is way slower.

Indeed the combination looks plausible :-)

> This is not AES-NI in the interrupt path, but I don't think there is a
> knob for that.

OK. So let's hope this works then !

Willy

