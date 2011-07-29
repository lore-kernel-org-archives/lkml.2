Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab1G2QsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 12:48:16 -0400
Received: from fieldses.org ([174.143.236.118]:48978 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab1G2QsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 12:48:15 -0400
Date: Fri, 29 Jul 2011 12:48:11 -0400
To: Greg Banks <gnb@fastmail.fm>
Cc: NeilBrown <neilb@suse.de>, linux-nfs@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Fw: [PATCH] sunrpc: use better NUMA affinities
Message-ID: <20110729164811.GK23194@fieldses.org>
References: <20110729153207.17af3085@notabene.brown>
 <4E324DB4.7060600@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E324DB4.7060600@fastmail.fm>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 04:05:40PM +1000, Greg Banks wrote:
> On 29/07/11 15:32, NeilBrown wrote:
> >
> >Hi Greg,
> >  I saw this patch float past and thought of you... You may not be interested
> >  any more, and it may be a perfectly good patch that does not need any
> >  comment, but I thought I would let you know anyway.
> 
> Thanks Neil.
> 
> I've trimmed the cc list to limit the number of copies Trond and Bruce get:)

I appreciate the thought, but in future please don't trim cc's.

--b.
