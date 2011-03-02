Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab1CBUZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 15:25:53 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:47524 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab1CBUZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 15:25:52 -0500
Date: Wed, 2 Mar 2011 21:25:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Vegard Nossum <vegard@kernel.org>
Subject: Re: RFC: x86: kill binutils 2.16.x?
Message-ID: <20110302202551.GA7191@merkur.ravnborg.org>
References: <4D6E8932.1010405@zytor.com> <20110302120339.efd60504.akpm@linux-foundation.org> <4D6EA473.9000001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6EA473.9000001@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 12:11:31PM -0800, H. Peter Anvin wrote:
> On 03/02/2011 12:03 PM, Andrew Morton wrote:
> > On Wed, 02 Mar 2011 10:15:14 -0800
> > "H. Peter Anvin" <hpa@zytor.com> wrote:
> > 
> >> binutils 2.16 (and presumably its prereleases, binutils 2.15.9x) appears
> >> to have more bugs than any other version of binutils released in modern
> >> history, *before or after*.
> >>
> >> We chronically run into problems because that particular binutils
> >> version breaks code that works fine elsewhere.
> >>
> >> I would like to know who would suffer from formally discontinuing
> >> support for that version.  I understand some version of SLES shipped it,
> >> but I don't know for sure.
> >>
> > 
> > I gave up and became a customer of
> > http://www.kernel.org/pub/tools/crosstool/index_old.shtml
> 
> Vegard,
> 
> The source directory in the above doesn't seem to match the binary
> directories, and is stuck at binutils 2.16.1.  At the very best this is
> iffy from a GPL perspective, and very confusing to users.
> 
> This is obviously a highly useful project, can we straighten out the
> source situation?

The binaries has never worked for me (on my Intel Atom 32 bit box).
Today I use crosstool-ng - which works great.
[Need to polish my patch to add saprc support...]

URL: http://ymorin.is-a-geek.org/projects/crosstool

	Sam
