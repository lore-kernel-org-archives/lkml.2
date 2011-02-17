Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab1BQT3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:29:38 -0500
Received: from symlink.to.noone.org ([85.10.207.172]:43334 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab1BQT3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:29:36 -0500
Date: Thu, 17 Feb 2011 20:29:35 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Chou <thomas@wytron.com.tw>, nios2-dev@sopc.et.ntust.edu.tw,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Nios2-dev] [PATCH 4/4] MAINTAINERS: Add myself as a
	maintainer for  altera_uart/altera_jtaguart
Message-ID: <20110217192935.GN4076@distanz.ch>
References: <cover.1297245277.git.tklauser@distanz.ch> <04c107d8032cbaffada91066c1d010b9274aebe1.1297245277.git.tklauser@distanz.ch> <4D5C9314.8030101@wytron.com.tw> <201102171902.41784.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102171902.41784.arnd@arndb.de>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 2011-02-17 at 19:02:41 +0100, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 17 February 2011, Thomas Chou wrote:
> > As we get more drivers merged into mainline, we might consider adding a 
> > general entry for all altera related drivers to our mailing list. We 
> > could add "F: arch/nios2" to this entry in the near future.
> 
> On a related topic, are there plans to submit the nios2 arch code
> for review any time soon?

I'm currently in contact with Altera on exactly this matter. We're
planning to submit the nios2 architecture code for review really soon
now.

> I'm usually reviewing all architectures that come in, and unicore32
> is almost ready to go in, so there is room to start reviewing the next
> one.

That's great to hear. I followed the submission and review of unicore32
a bit and read some of your replies on how to proceed. I already learned
a lot from that and will try to apply it for the nios2 submission.

> I expect nios2, lm32 and c64x to be submitted this year, but I'll
> probably only be able to review one at time. First come, first
> serve.

So I hope we'll be the first ones then :-)

Thanks a lot for your notice

Tobias
