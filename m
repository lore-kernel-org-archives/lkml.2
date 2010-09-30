Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab0I3JvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:51:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44168 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab0I3JvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:51:07 -0400
Date: Thu, 30 Sep 2010 11:51:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: huang ying <huang.ying.caritas@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>, Huang Ying <ying.huang@intel.com>,
        Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v2 6/7] x86, NMI, Add support to notify hardware error with unknown NMI
Message-ID: <20100930095102.GG21952@one.firstfloor.org>
References: <AANLkTimY5hr3DgN9=v83Z289MkzjgX8k0WzdTWZbGorj@mail.gmail.com> <20100927133816.GP13563@erda.amd.com> <20100927152014.GY26290@redhat.com> <1285634172.20791.92.camel@yhuang-dev> <20100928153247.GL26290@redhat.com> <AANLkTinmhTgVhPsmGLC8Z-9Kx3xRovWy=9+R_5B4u6Cx@mail.gmail.com> <20100930043628.GE26290@redhat.com> <1285822630.6944.69.camel@yhuang-dev> <20100930083806.GU13563@erda.amd.com> <AANLkTimWwO=6uOxxXdSgOU2vWY8a-XeW1b+GRyua2Brw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimWwO=6uOxxXdSgOU2vWY8a-XeW1b+GRyua2Brw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That is possible. I just don't like it. We should keep things as
> "straightforward" as possible. Direct call is more straightfoward than
> indirect call like notifier chain.

Fully agreed.  Indirect calls should be only used when absolutely
needed due to their impact on code maintainability.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
