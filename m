Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab1IPVsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 17:48:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41311 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab1IPVsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 17:48:24 -0400
Date: Fri, 16 Sep 2011 16:48:20 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: trouble daemon <troubledaemon@gmail.com>
Cc: linux-kernel@vger.kernel.org, aystarik@gmail.com, x86@kernel.org,
        586494@bugs.debian.org
Subject: Re: Dell PowerEdge 4200 scsi, worked in 2.6.18, not in 2.6.26
Message-ID: <20110916214820.GJ4683@elie>
References: <AANLkTim7_OzJfwbtk0fE5ScH8zZwZ_uJeo5pJFOhkHu_@mail.gmail.com>
 <20110912065618.GA23340@elie>
 <CAK82gMFdUy5Dm+FpkrjuEeP9W6BFfGL4U0h-FP8b6BmMHAH1Ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK82gMFdUy5Dm+FpkrjuEeP9W6BFfGL4U0h-FP8b6BmMHAH1Ww@mail.gmail.com>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trouble daemon wrote:

> As for later kernels, I have no idea tbh. Currently they seem to run
> flawless with noapic, so that is what I use when installing and
> running them. I do know that the Debian Squeeze installer chokes if I
> don't use noapic, however.
>
> If you are interested in some closure, I suppose I could take a shot
> at installing something a little more recent and see if I can get away
> with removing noapic though. Just let me know what kernel source
> (vanilla/deb sid/etc), version, or any particular .config options that
> you would like me to test, and I can see about pasting the console
> terminal output when running without noapic disabled.

Thanks!  Really, anything 3.0 or later would be interesting (mainline
is better than distro-patched), with a .config that panics in an older
version.  Testing with a stock Debian squeeze kernel would be
interesting, too.
