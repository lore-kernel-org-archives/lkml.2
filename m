Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab2GCTqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:46:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37342 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2GCTq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:46:28 -0400
Date: Tue, 3 Jul 2012 20:46:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: arnd@arndb.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com, x86@kernel.org,
        gregkh@linuxfoundation.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
Message-ID: <20120703194605.GB26355@n2100.arm.linux.org.uk>
References: <201207031319.40884.arnd@arndb.de> <2b797c83-6a3c-4051-841a-a4cfa9d1cae1@email.android.com> <20120701104401.GA4352@mail.gnudd.com> <20120703130042.GA10007@mail.gnudd.com> <20120703132641.GA28437@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120703132641.GA28437@mail.gnudd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 03:26:41PM +0200, Alessandro Rubini wrote:
> I already have this in place for other drivers that I'm going to use
> with the pci-amba bridge. They have already been picked up by Rusell,
> but they are not in linux-next yet.  So maybe other people have more
> errors than me related to sizes.h, but this for mmci is trivial with
> the other stuff in place.
> 
> Ok for the rest, I'll submit a patch set following your suggestions
> when the other sizes.h stuff reaches linux-next.

I've not pushed them into linux-next, because my nightly test builds
for Versatile were failing due to the LEDS stuff in arm-soc, and
that's one of the platforms your patches have the potential to affect.

Now that the LEDS stuff has been dropped out of arm-soc, the build
results are a lot more promising, and I'm now happier to move them
into linux-next.
