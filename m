Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab1HZAEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 20:04:14 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:50313 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752912Ab1HZAEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 20:04:12 -0400
X-Sasl-enc: zrnfOBgnyTzundyIrm+nB1/D7JkJUeOrJyRAjW3xtMWV 1314317051
Date: Thu, 25 Aug 2011 17:03:28 -0700
From: Greg KH <greg@kroah.com>
To: Brian Swetland <swetland@google.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tim Bird <tbird20d@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, stable-review@kernel.org, stable@kernel.org,
        tim.bird@am.sony.com,
        Arve =?iso-8859-1?Q?Hj=F8nnev=E5?= <arve@android.com>
Subject: Re: Future of the -longterm kernel releases (i.e. how we pick them).
Message-ID: <20110826000328.GA1314@kroah.com>
References: <20110815041524.GA7578@kroah.com>
 <CA+bK7J7_EKdQACnoJGWkd4asH+096SJ-gjEvsnjmRX6Dmc6dpA@mail.gmail.com>
 <20110817045856.GB4936@kroah.com>
 <20110817132114.GB10209@sirena.org.uk>
 <CANqkERC2eyy3SQ6_vJncvuMdi=Yu=O8mZoXkggkX1q_4=d+q7g@mail.gmail.com>
 <20110824045702.GA1674@kroah.com>
 <CANqkERC9evgXzOMMiqtyvu3RsoUQWdUAh47yRNz1JjmB4Vydbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANqkERC9evgXzOMMiqtyvu3RsoUQWdUAh47yRNz1JjmB4Vydbg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 09:49:22PM -0700, Brian Swetland wrote:
> On Tue, Aug 23, 2011 at 9:57 PM, Greg KH <greg@kroah.com> wrote:
> > On Wed, Aug 17, 2011 at 10:33:05AM -0700, Brian Swetland wrote:
> >> As far as long-term kernels goes, from the Android perspective we
> >> strongly prefer to snap up to the most recent released kernel on every
> >> platform/device release.  I prefer to be as up to date on bugfixes and
> >> features from mainline as possible and minimize the deltas on our
> >> stack 'o patches as much as possible.
> >
> > That's good to hear.
> >
> >> We've been getting more aggressive about merging in the -rc#s and then
> >> rebasing on the final during development (before final stabilization
> >> freeze for a release) in the last year or so, and it seems to work
> >> pretty well.
> >
> > Is your kernel git tree public during this merge cycle so that others
> > can track it?  I tried to dig through android.kernel.org but there are a
> > lot of different kernel trees there :(
> 
> We really need a "which branch is which" quick guide that's easily
> findable.  kernel/common is always where our generic patch stack
> lives, and it looks like android-3.0 is the most recent (which has
> 3.0.1 merged in).
> 
> http://android.git.kernel.org/?p=kernel/common.git;a=summary

Thanks for the pointer.

If you ever get such a quick guide, I'd appreciate a link to it.

greg k-h
