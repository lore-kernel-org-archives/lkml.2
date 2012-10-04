Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab2JDW2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:28:47 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:51127 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2JDW2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 18:28:46 -0400
Date: Thu, 4 Oct 2012 15:28:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Re: 3.4.10 i915 [GM45] regression
Message-ID: <20121004222842.GE3609@kroah.com>
References: <2372445.fuIXicT4H0@tux200s>
 <20120930143201.GA22107@kroah.com>
 <CAKMK7uE-L-+bFxJad3-pa-8i2MwvYw4_vYoWM8S-bxRmKruzoQ@mail.gmail.com>
 <6616255.1baV4zcIkN@tux200s>
 <CAKMK7uEuRN1WerdF1KEDzova4Qe_hY20i3N=HeNVwvRYxf6gsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uEuRN1WerdF1KEDzova4Qe_hY20i3N=HeNVwvRYxf6gsw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 09:17:22AM +0200, Daniel Vetter wrote:
> On Mon, Oct 1, 2012 at 11:56 PM, Andreas Sturmlechner
> <andreas.sturmlechner@gmail.com> wrote:
> >> Andreas, can you please check whether 3.5.x works for you, just to
> >> make sure that this particular elephant is only wreaking havoc in 3.4
> >> and earlier?
> >
> > I've been using 3.5 all the time since .0, I never had any trouble there - a few reboots just now with a vanilla 3.5.4 image were
> > successful as expected. Meanwhile I have upgraded to 3.6, zero issues as well.
> 
> So 3.5 and later really don't seem to have any issue with this patch.
> I'm as puzzled as ever. Thanks for testing this again.

I forgot to revert this for 3.4, I'll do so in the next 3.4-stable
release after this one, thanks.

greg k-h
