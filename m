Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab2GALFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 07:05:19 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:42499 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab2GALFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 07:05:16 -0400
Date: Sun, 1 Jul 2012 13:04:54 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux@arm.linux.org.uk
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, x86@kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
Message-ID: <20120701110454.GA17531@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20120701105934.GD16319@n2100.arm.linux.org.uk>
References: <20120701105934.GD16319@n2100.arm.linux.org.uk>
  <4FECB95D.7010200@zytor.com> <cover.1338222460.git.rubini@gnudd.com>
 <f85fefb10b7a7407b77180be65b18bf0426145b9.1338222461.git.rubini@gnudd.com>
 <20120701104401.GA4352@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the answer is... those primecell drivers need fixing in some way.

Ok. I'm going to attack them and make a report.

> As for PL08x, which depends on asm/hardware/pl080.h,

We have pl080 under PCI, so we have patches in the queue to fix this
header problem.  I just didn't submit them yet, but now they are part
of this fixup effort and I'll check them over.

> Note also that hpa has only reported the first errors he encountered, so
> there may be more, and that's somehting which needs checking.

Yes. I'm going to make a status report soon, counting and classifying
all errors I encounter when enabling all amba drivers under x86.

thanks
/alessandro
