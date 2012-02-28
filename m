Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab2B1WzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:55:01 -0500
Received: from mail.us.es ([193.147.175.20]:54754 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409Ab2B1Wy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:54:59 -0500
Date: Tue, 28 Feb 2012 23:54:46 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Dave Taht <dave.taht@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, jengelh@medozas.de, rostedt@goodmis.org,
        basti@b-bl.de
Subject: Re: [PATCH 1/2] iptables: Merge libip6t_LOG and libipt_LOG into
 libxt_LOG
Message-ID: <20120228225446.GA30124@1984>
References: <1328911856-19260-1-git-send-email-richard@nod.at>
 <1328911856-19260-2-git-send-email-richard@nod.at>
 <20120225133816.GA15864@1984>
 <4F4CFB6D.4000403@nod.at>
 <CAA93jw5AfWbU8Gsx1WtJSkTox7bMAjkeuojaMXgwWgdAyROMGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA93jw5AfWbU8Gsx1WtJSkTox7bMAjkeuojaMXgwWgdAyROMGw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 05:15:59PM +0100, Dave Taht wrote:
> On Tue, Feb 28, 2012 at 5:06 PM, Richard Weinberger <richard@nod.at> wrote:
> > Am 25.02.2012 14:38, schrieb Pablo Neira Ayuso:
> >> On Fri, Feb 10, 2012 at 11:10:51PM +0100, Richard Weinberger wrote:
> >>> libip6t_LOG and libipt_LOG share a lot of common code, merge them
> >>> to recude duplicate code.
> >>
> >> I have applied this to the net-next branch of iptables.
> >>
> >> See git.netfilter.org
> >>
> >> I'll merge it to master once linux kernel 3.3 is released.
> >
> > Okay. What about the ring buffer feature?
> > Is there anything missing?
> 
> I'm under the impression that the ecn related changes didn't make it
> as yet. I'm in a position to test that stuff this month, if it needs
> further testing and hasn't actually made it in.

You mean this?

commit af0d29cd2a732f70882e6122b9f9df8b0d84515e
Author: Patrick McHardy <kaber@trash.net>
Date:   Thu Jun 9 15:20:27 2011 +0200

    netfilter: xtables: add an IPv6 capable version of the ECN match

It's already 3.3-rc.
