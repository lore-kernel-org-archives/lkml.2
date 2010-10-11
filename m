Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab0JKRJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:09:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:26948 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668Ab0JKRJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:09:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,315,1283756400"; 
   d="scan'208";a="334739737"
Date: Mon, 11 Oct 2010 19:11:51 +0200
From: Andi Kleen <ak@linux.intel.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>
Subject: Re: [PATCH] Define _addr_lsb in siginfo_t for mips and ia64
Message-ID: <20101011171113.GA8959@gargoyle.nowhere.org>
References: <1286560501-26843-1-git-send-email-andi@firstfloor.org>
 <987664A83D2D224EAE907B061CE93D530163EA9C09@orsmsx505.amr.corp.intel.com>
 <AANLkTin7_3_iwn2xf=wy9ho9GfCHw+eSTjv12z1ESWr5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin7_3_iwn2xf=wy9ho9GfCHw+eSTjv12z1ESWr5@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 09:53:22AM -0700, Tony Luck wrote:
> On Fri, Oct 8, 2010 at 11:13 AM, Luck, Tony <tony.luck@intel.com> wrote:
> > ia64 has HAVE_ARCH_COPY_SIGINFO_TO_USER - so it doesn't see
> > this build problem because the version of copy_siginfo_to_user()
> > in kernel/signal.c isn't the one we use. So I don't think that
> > we need this (unless someone has some plan to unify the
> > ARCH specific version).
> 
> I take this back ... in next-20101011 the disease has spread:

Ok I will include the patch for ia64 in my tree -- unless you
want to carry it.

-Andi
