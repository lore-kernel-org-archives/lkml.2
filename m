Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab2CSA2V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 20:28:21 -0400
Received: from mail.us.es ([193.147.175.20]:49409 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036Ab2CSA2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 20:28:19 -0400
Date: Mon, 19 Mar 2012 01:28:11 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: kaber@trash.net, davem@davemloft.net, Dave Jones <davej@redhat.com>,
        netfilter-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, Christoph Lameter <cl@linux.com>
Subject: Re: netfilter: Hung task
Message-ID: <20120319002811.GA30408@1984>
References: <CA+1xoqfCTXxXsbfUjttuOVutyD_FzYS8PoOoAOOtB72P8SwdVg@mail.gmail.com>
 <20120318141943.GA28850@1984>
 <CA+1xoqcQYqCgQb=1M5PVkm=6SBhV2oJxJ2CtBp=gAvZM36Kc2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqcQYqCgQb=1M5PVkm=6SBhV2oJxJ2CtBp=gAvZM36Kc2Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 10:52:55PM +0200, Sasha Levin wrote:
> On Sun, Mar 18, 2012 at 4:19 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sun, Mar 18, 2012 at 12:55:13PM +0200, Sasha Levin wrote:
> >> Hi all,
> >>
> >> I got the following spew after fuzzing using trinity on a KVM tools
> >> guest, using the latest linux-next.
> >>
> >> It reminds me a lot of https://lkml.org/lkml/2012/3/14/375 and
> >> https://lkml.org/lkml/2012/1/14/45
> >
> > You mention neither Linux kernel version nor the way you trigger this.
> >
> > With that little information it's really hard to really know.
> 
> Hum? I've mentioned it happened with "the latest linux-next" (which is
> currently two days old), and using the trinity fuzzer - which means
> that I don't have a specific method to reproduce the problem.

Sorry, I should not read my email diagonally, really.

Looking at the trace, I'd point to some problem in the slub memory
allocator. Please, correct me if I'm wrong.

Christoph?
