Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab2DFRWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 13:22:14 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:62384 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab2DFRWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 13:22:12 -0400
Date: Fri, 6 Apr 2012 19:21:40 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: robherring2@gmail.com
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/1] Renaming AMBA to PRIMECELL
Message-ID: <20120406172140.GA16326@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <4F7F20DE.3040009@gmail.com>
References: <4F7F20DE.3040009@gmail.com>
  <cover.1333663714.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank your Rob for replying.
I acknowledge the reasoning has not been discussed.

> While I agree this is a more correct name, I think this is pointless
> churn and as you highlight above incomplete.

I don't know. I can't evaluate the "pointless" bit.  I leave this
decision to people more involved with the fpga/asic/cpu environment.

> What's the reasoning for this other than rmk suggested it?

My aim is using primecell for x86: my target chip is a pci-e bridge
that exposes a number of amba devices to the PC; some of those are
PrimeCell devices for which the existing drivers work fine after you
set up stuff correctly.  While touching this stuff I"ve been asked to
make the rename, and for me "rmk suggested it" is strong enough a
reason.

I suspect this misnaming may be disturbing in some technical
environments; it's known that amba is being used in many
environments without primecell logic blocks, and it's now spreading
fast to non-arm SoC's. It may happen that a new user base may
be confused by a misnaming (e.g., my ata is under amba, but it's not
a primecell block, so it's not including <linux/amba.h>).

It's not unlike how IDE became ATA over time.  If there's agreement
about its usefulness I can deal with the move, before submitting the
bridge.  Otherwise I'm also fine with using the old naming in my
patches.

/alessandro, feeling flame alert, thus maybe too verbose
