Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab1GLI26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:28:58 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:45425
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813Ab1GLI24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:28:56 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de p6C8R1OR021942
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Keith Packard <keithp@keithp.com>
Cc: Pekka Enberg <penberg@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Robse <rob-se@live.de>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Bug #37472] Lenovo U160 (i915 black screen)
In-Reply-To: <yun7h7pg8y7.fsf@aiko.keithp.com> (Keith Packard's message of
	"Sun, 10 Jul 2011 13:46:40 -0700")
References: <AtAvQwe5sAK.A.loH.OlYGOB@chimera>
	<gK_efVqs2fP.A.NJ.7lYGOB@chimera>
	<CAOJsxLGkWX61TLqwgL19tN5ZQuB2cUibPsNSvCB+Ydihtus__w@mail.gmail.com>
	<yun7h7pg8y7.fsf@aiko.keithp.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Tue, 12 Jul 2011 10:27:01 +0200
Message-ID: <gisjqb6h0q.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Tue, 12 Jul 2011 10:27:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith Packard <keithp@keithp.com> writes:

> On Sun, 10 Jul 2011 14:56:19 +0300, Pekka Enberg <penberg@kernel.org> wrote:
>
>> There's no mention that the i915 developers know about this problem so
>> I'm CC'ing Keith and Chris.
>
> Thanks. I've added a comment to the bug:
>
> First off, of course you are encouraged to re-test with 3.0-rc6 just to
> make sure it hasn't changed in some way. I don't think anything has
> changed enough to affect this, but it's always good to be sure.
>
> I note a long sequence of patches that are supposed to help with the
> U160:
>
> 448f53a1ede54eb854d036abf54573281412d650 drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks
> bcfbbce822d219eb587acaba8a6e062bbeae4761 Revert "drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks"
> a76150302d6e7ebc43e1a1ddaee7fd51db8da3b3 drm/i915: Add a module option to override the use of SSC
>
> I'm not sure why a quirk wasn't added for this hardware; it's clearly
> 'non-standard' in some mystic way.

On June 27th, I proposed that Robse perhaps could try the workaround
that was introduced with the latter commit: i915.lvds_use_ssc=0.

It works well on my hardware and probably solves his problem as well,
but he did not respond...

Dirk

[1] https://lkml.org/lkml/2011/6/27/45
