Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab0KQEH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 23:07:27 -0500
Received: from waste.org ([173.11.57.241]:49525 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab0KQEH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 23:07:26 -0500
Subject: Re: Behavior of BUG() [Was: Re: [PATCH 2/5] of/fdt: add kernel
 command line option for dtb_compat string]
From: Matt Mackall <mpm@selenic.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kernel@vger.kernel.org, dirk.brandewie@gmail.com,
        linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <AANLkTinop4_JT4JLtdmWkydPgDDU=TyZNbtiBbgeh1dj@mail.gmail.com>
References: <AANLkTinop4_JT4JLtdmWkydPgDDU=TyZNbtiBbgeh1dj@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 22:07:23 -0600
Message-ID: <1289966843.26343.359.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 22:45 -0500, Arnaud Lacombe wrote:
> Hi,
> 
> [CC: list reduced as starting a new thread, most on the context
> removed as this concern a different issue.]
> 
> On Tue, Nov 16, 2010 at 7:16 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> > On Tue, Nov 16, 2010 at 3:41 PM,  <dirk.brandewie@gmail.com> wrote:
> >> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> >> [...]
> > The kernel needs to complain *loudly* if this occurs because it
> > represents a bug.  I'm tempted to say use BUG, but that would halt the
> > kernel and prevent any possibility of kernel log output.
> > [...]
> does it ? if CONFIG_BUG is not enabled and the arch has no define for
> it, the default does _nothing_:

That's because CONFIG_BUG=N is intended for machines where logging is
irrelevant/impossible. You are encouraged to ignore all options under
CONFIG_EMBEDDED when trying to have a sensible discussion.

-- 
Mathematics is the supreme nostalgia of our time.


