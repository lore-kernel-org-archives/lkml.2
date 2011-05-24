Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab1EXSXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:23:39 -0400
Received: from mail.lang.hm ([64.81.33.126]:57679 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab1EXSXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:23:38 -0400
Date: Tue, 24 May 2011 11:23:34 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Richard Yao <ryao@ic.sunysb.edu>
cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: UNIX Compatibility
In-Reply-To: <BANLkTi=q7tDVkahrnng7+BJhvxh=gx71ng@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1105241116190.23692@asgard.lang.hm>
References: <BANLkTin4wu1HNDeo8Rv7iddM9KkgZdhfgA@mail.gmail.com> <A7E21A2F-4338-465D-933A-66B0C4D15BE1@mit.edu> <BANLkTi=q7tDVkahrnng7+BJhvxh=gx71ng@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Richard Yao wrote:

> With that out of the way, I am under the impression that the Linux
> kernel code is in some way incompatible with the Single Unix
> Specification (i.e. the thing required for an OS to be certified as
> being UNIX).

I beleive it's less a matter of being incompatible and more a matter of 
not having been certified as being compatible.

a historic note: at the time that Linux was getting started, getting 
certified as Unix was a very expensive undertaking (and Linux definantly 
did not comply in the early days anyway). Even getting the full specs was 
an expensive thing (at least for an individual)

as such, there are probably some differences that crept in (like the error 
codes you refer to below), but the biggest difference is that there are 
additional system calls available on Linux compared to Unix

That being said, the differences are minor enough that many flavors of 
Unix have implemented Linxu compatibility layers to support unmodified 
linux binarires, and recompiling code written for Unix almost always 'just 
works' on Linux (the biggest issue is usually libraries)

> It seems Linus Torvalds wanted to use the UNIX System V call codes
> when he was working on Linux 0.0.1, but he lacked a reference at the
> time, so he only got them partially right. Considering that the error
> codes were originally intended to be compatible with UNIX System V, it
> might be worth changing them to match. The Linux 3.0 change would
> probably be a good time for this.

and what exactly would the advantage be of breaking backwards 
compatibility with all existing linux code?

I don't see any real advantage.

David Lang
