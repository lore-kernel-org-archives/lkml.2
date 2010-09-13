Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972Ab0IMThR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:37:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab0IMThP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:37:15 -0400
Date: Mon, 13 Sep 2010 15:36:55 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100913193655.GF26290@redhat.com>
References: <20100910184039.GK4879@redhat.com>
 <1284344389.3269.82.camel@yhuang-dev.sh.intel.com>
 <20100913141140.GB27371@redhat.com>
 <20100913172438.37443bf7@basil.nowhere.org>
 <20100913154750.GA26290@redhat.com>
 <20100913185721.59ad9b4d@basil.nowhere.org>
 <20100913175346.GC26290@redhat.com>
 <20100913200707.3b31429e@basil.nowhere.org>
 <20100913182354.GE26290@redhat.com>
 <20100913203654.26724055@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913203654.26724055@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 08:36:54PM +0200, Andi Kleen wrote:
> 
> > > 
> > > But if it's generic if not on the screen it should
> > > be at least in the error serialization data and logged after boot.
> > 
> > I guess I don't know what that is, 'error serialization data'.  Is
> > there somewhere I can read more about it?
> 
> That's already supported in MCE -- saving the error record to NVRAM
> and logging it after reboot. NMI should probably do the same.
> It's much nicer than getting it from a console.

Hmm, that assumes these boxes have NVRAM.  I am not sure if many of the
boxes I see with problems have NVRAM on them.

> 
> > > 
> > > At least on PCI-E it may be enough to simply dump all recent AER
> > > data.
> > 
> > This assumes AER is supported on the bridge?  Which for newer chips is
> > probably true, but I wasn't sure about older ones.
> 
> Today's servers should usually have AER at least.
> 
> For old systems you only can get the few bits in PCI space.
> 
> > How would I dump AER data from within the kernel?
> 
> Would need a buffer that is dumped for past events and 
> reading the registers for not yet reported. Right now some
> infrastructure is needed.

Oh ok.

Cheers,
Don
