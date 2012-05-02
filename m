Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab2EBXDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 19:03:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54018 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755209Ab2EBXDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 19:03:24 -0400
Date: Thu, 3 May 2012 00:03:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] extcon: Add EXTCON_MECHANICAL cable type for physical
	presence
Message-ID: <20120502230322.GB19693@opensource.wolfsonmicro.com>
References: <1335951531-5967-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20120502201321.GA26275@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502201321.GA26275@kroah.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 01:13:21PM -0700, Greg Kroah-Hartman wrote:

> Ok, but where is the in-kernel user of this new interface?  Why are we
> adding it now before someone actually needs it?

Well, one could say the same thing about the entire interface right now
but if you look at the existing accessory detection abstraction for
sound cards in include/sound/jack.h and the input API that's currently
the only userspace API for it you can see that they have this feature
already.

There's a reasonable prospect of the ALSA abstraction getting support
for extcon at some point in the not too distant future at which point it
will acquire all the users that has but I'd not anticipate that until
after the merge window as the ALSA stuff wants some prodding and poking 
prior to doing that which I really hope will collide with some other
updates too.

> And shouldn't this also update some documentation somewhere as well?

There doesn't appear to be any existing relevant documentation to
update, and to be honest given that what we're doing is mapping a plain
text name into a constant I'm not sure it'd be adding much.
