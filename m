Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab0K2GHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 01:07:43 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48854 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab0K2GHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 01:07:41 -0500
MIME-Version: 1.0
In-Reply-To: <20101129055529.GB17113@yookeroo>
References: <1290607413.12457.44.camel@concordia> <1290692075.689.20.camel@concordia>
 <20101129055529.GB17113@yookeroo>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 28 Nov 2010 23:07:20 -0700
X-Google-Sender-Auth: 5ZNSIXdbI5HOuG5KI0gVD2MP83w
Message-ID: <AANLkTi=KBsMDvG2wZDu6ZtctWzd_bdQ=tO97eZu1R+VL@mail.gmail.com>
Subject: Re: RFC: Mega rename of device tree routines from of_*() to dt_*()
To: Michael Ellerman <michael@ellerman.id.au>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>,
        microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        sparclinux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 28, 2010 at 10:55 PM, David Gibson
<david@gibson.dropbear.id.au> wrote:
> On Fri, Nov 26, 2010 at 12:34:35AM +1100, Michael Ellerman wrote:
>> Most of these are straight renames, but some have changed more
>> substantially. The routines for the flat tree have all become fdt_foo().
>
> I'm a little uneasy about using the same prefix as libfdt (fdt_foo())
> for routines that have a different implementation and different names
> / semantics to the libfdt routines.

I'd also be okay with either dtflat_ or flatdt_ for the prefix on
these routines.

g.
