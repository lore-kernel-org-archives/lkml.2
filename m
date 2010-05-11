Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab0EKSrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:47:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33155 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab0EKSrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:47:33 -0400
Date: Tue, 11 May 2010 19:47:19 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Brian Swetland <swetland@google.com>
Cc: Theodore Tso <tytso@mit.edu>, Arve Hj?nnev?g <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100511184718.GA8732@sirena.org.uk>
References: <m2oa55d774e1005051356n3610d780ra42200c1785e02bd@mail.gmail.com> <20100505234025.GB4838@opensource.wolfsonmicro.com> <l2kd6200be21005052125rc43217a2r8c65bc98e7a5d3d4@mail.gmail.com> <20100507100406.GA21498@rakim.wolfsonmicro.main> <w2kd6200be21005070357r9aad2896l355168a23bf85eae@mail.gmail.com> <20100507112102.GC21498@rakim.wolfsonmicro.main> <81818215-44A2-4B74-A43F-E2644C950F5C@mit.edu> <20100507122520.GD21498@rakim.wolfsonmicro.main> <z2wa55d774e1005070537k8e3cb6baxc74e998e930d254d@mail.gmail.com> <20100507133025.GA23983@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507133025.GA23983@rakim.wolfsonmicro.main>
X-Cookie: Kiss your keyboard goodbye!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 02:30:25PM +0100, Mark Brown wrote:

> I mean that I will extend the embedded audio subsystem that the kernel
> already has (ASoC, in sound/soc) to support ignoring suspends for some
> audio paths so that they can be kept up during suspend.  This will be
> primarily intended for use with opportunistic suspend but not specific
> to it.

Just for the record I've now done an implementation of this which should
show up in -next when it's rebuilt and 2.6.35.  It's not the most
thoroughly tested code I've ever written but I'm fairly happy it'll do
the right thing, especially for analogue basebands.  The functionality
needs to be explicitly requested by machine drivers so there should be
no impact on systems using suspend in a more standard fashion.

This means that there should be even less of an issue merging this from
an audio point of view.
