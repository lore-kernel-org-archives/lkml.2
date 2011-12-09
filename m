Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab1LIOzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:55:23 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:57658 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab1LIOzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:55:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20194.8535.854625.466329@quad.stoffel.home>
Date: Fri, 9 Dec 2011 09:55:19 -0500
From: "John Stoffel" <john@stoffel.org>
To: Colin Walters <walters@verbum.org>
Cc: John Stoffel <john@stoffel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: chroot(2) and bind mounts as non-root
In-Reply-To: <1323368800.10724.73.camel@lenny>
References: <1323280461.10724.13.camel@lenny>
	<20191.49202.793643.397028@quad.stoffel.home>
	<1323360655.10724.35.camel@lenny>
	<20192.65168.140290.462594@quad.stoffel.home>
	<1323368800.10724.73.camel@lenny>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Colin" == Colin Walters <walters@verbum.org> writes:

Colin> On Thu, 2011-12-08 at 13:14 -0500, John Stoffel wrote:
>> Or is it because you're trying to edit on one OS, such a fedora 14,
>> then build and debug inside an Debian 5.0 setup?  But without running
>> a completely seperate system, but just doing a chroot into a new
>> filesystem tree?  

Colin> Yes, something like that; basically it's about ensuring that
Colin> the libfoo we're building binaries against is
Colin> /home/walters/build/libfoo.so and not /usr/lib/libfoo.so.

Colin> I'm actually intending for the core build system of my OS to
Colin> work in *both* cross and native compilation.  That means it's
Colin> important to keep them as close as possible.

Colin> What you were talking about above (i.e. "just don't chroot") is
Colin> what http://buildroot.net does (and others, I also
Colin> semi-maintain GNOME's jhbuild).  It works if you're very
Colin> careful in your build scripts, know and carefully propagate the
Colin> large set of magic environment variables, etc., then yes, you
Colin> can do it.

Colin> But chroot is just so nice a hammer for this nail.

I can see that, but maybe you can still fix this in userspace using
the schroot tool others have mentioned.  

John
