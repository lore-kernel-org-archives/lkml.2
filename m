Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156Ab2GCN1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:27:09 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:37718 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932938Ab2GCN1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:27:07 -0400
Date: Tue, 3 Jul 2012 15:26:41 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: arnd@arndb.de
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, linux@arm.linux.org.uk, x86@kernel.org,
        gregkh@linuxfoundation.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
Message-ID: <20120703132641.GA28437@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <201207031319.40884.arnd@arndb.de>
References: <201207031319.40884.arnd@arndb.de>
  <2b797c83-6a3c-4051-841a-a4cfa9d1cae1@email.android.com>
 <20120701104401.GA4352@mail.gnudd.com>
 <20120703130042.GA10007@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Arnd Bergmann:

> Note that there is already an include/linux/amba/pl08x.h.
> I would just move the few parts of pl080.h that are actually
> needed with global visibility there, and move the rest
> to drivers/dma/.

Ok.

>>   proposed fix: use linux/sizes.h and provide readsl/writesl like others do

> Ack on the linux/sizes.h, that definitely makes sense.

I already have this in place for other drivers that I'm going to use
with the pci-amba bridge. They have already been picked up by Rusell,
but they are not in linux-next yet.  So maybe other people have more
errors than me related to sizes.h, but this for mmci is trivial with
the other stuff in place.

Ok for the rest, I'll submit a patch set following your suggestions
when the other sizes.h stuff reaches linux-next.

/alessandro
