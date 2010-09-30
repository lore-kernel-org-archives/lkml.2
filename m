Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0I3IZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 04:25:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53686 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab0I3IZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 04:25:46 -0400
Date: Thu, 30 Sep 2010 10:25:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Huang Ying <ying.huang@intel.com>,
        Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error with unknown NMI
Message-ID: <20100930082546.GF21952@one.firstfloor.org>
References: <1285549026-5008-1-git-send-email-ying.huang@intel.com> <1285549026-5008-6-git-send-email-ying.huang@intel.com> <20100927100901.GC32222@erda.amd.com> <AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com> <20100927133816.GP13563@erda.amd.com> <20100927152014.GY26290@redhat.com> <1285634172.20791.92.camel@yhuang-dev> <20100928153247.GL26290@redhat.com> <AANLkTinmhTgVhPsmGLC8Z-9Kx3xRovWy=9+R_5B4u6Cx@mail.gmail.com> <20100930043628.GE26290@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930043628.GE26290@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think the southbridge drivers should go notifier block, but the port
> > 0x61 code is architectural and should be kept in default_do_nmi().
> 
> Is port 0x61 architectural?  I thought it a southbridge thing.  In fact I

Technically not part of x86, It is part of the "PC" defacto standard.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
