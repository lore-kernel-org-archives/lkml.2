Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab2JCVEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:04:20 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55835 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab2JCVET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:04:19 -0400
Date: Wed, 3 Oct 2012 14:04:07 -0700
From: Kees Cook <kees@outflux.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Nick Bowler <nbowler@elliptictech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.6
Message-ID: <20121003210407.GC9092@outflux.net>
References: <CA+55aFw1Y5_HtfXh+-OEQ2KGpW0N18kA4O3R7=cv29_CaF+3UQ@mail.gmail.com>
 <20121003194614.GA2893@elliptictech.com>
 <20121003200515.GZ9092@outflux.net>
 <CA+55aFwgF1O_DzF0bqGO06n2kxNGE=f5BQsvZF_+q9o0pFPeGw@mail.gmail.com>
 <20121003204141.GB6026@thunk.org>
 <20121003204919.GA9092@outflux.net>
 <CA+55aFwXLXfAHHBEYYiz_4qjxWUpENECCZwFN_1gq+e48f+3Sw@mail.gmail.com>
 <20121003205818.GB9092@outflux.net>
 <20121003220525.780cf3f2@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003220525.780cf3f2@pyramind.ukuu.org.uk>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 10:05:25PM +0100, Alan Cox wrote:
> > If this happens, I _really_ want to bring back the CONFIG options I had in
> > an earlier version of this patch. I want to be able to declare the default
> > at build time, and not leave a system vulnerable from boot until sysctls
> > get set.
> 
> If your early boot code trusts a random writeable user directory I think
> you have other problems.

You should see some of the things various Android devices do! :)

-Kees

-- 
Kees Cook                                            @outflux.net
