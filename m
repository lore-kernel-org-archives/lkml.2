Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab0C3SMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:12:18 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40463 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0C3SMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:12:17 -0400
Date: Tue, 30 Mar 2010 13:12:04 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Add PGM protocol support to the IP stack
In-Reply-To: <4BB13133.6030500@zytor.com>
Message-ID: <alpine.DEB.2.00.1003301311070.26463@router.home>
References: <alpine.DEB.2.00.1003181245050.23010@router.home> <87tysccjrn.fsf@basil.nowhere.org> <alpine.DEB.2.00.1003220916170.15360@router.home> <20100322163609.GZ20695@one.firstfloor.org> <alpine.DEB.2.00.1003221146260.17230@router.home>
 <877hp4i76d.fsf@basil.nowhere.org> <alpine.DEB.2.00.1003221300180.17230@router.home> <20100322185310.GA20695@one.firstfloor.org> <4BB13133.6030500@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010, H. Peter Anvin wrote:

> On 03/22/2010 11:53 AM, Andi Kleen wrote:
> >
> > There's just no portable atomic64_t. Ok maybe you can use the socket lock
> > to synchronize all the counts if they are only per socket.
> >
>
> In 2.6.34 there is (although some arches which could support it natively
> don't as of yet... but that's fixable.)  See lib/atomic64.c.

There are also the 64bit thiscpu operations that were merged in 2.6.33.
They do the right thing if the arch does not provide operations.


