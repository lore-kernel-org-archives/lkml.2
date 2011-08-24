Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab1HXVPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:15:39 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39355 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab1HXVPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:15:37 -0400
Date: Wed, 24 Aug 2011 17:15:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH 01/75] net: add APIs for manipulating skb page fragments.
Message-ID: <20110824211519.GA28813@dumpdata.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
 <1313760467-8598-1-git-send-email-ian.campbell@citrix.com>
 <20110824182113.GF15675@dumpdata.com>
 <1314220141.17978.693.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1314220141.17978.693.camel@dagon.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E5569F2.00B8:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 10:09:01PM +0100, Ian Campbell wrote:
> On Wed, 2011-08-24 at 19:21 +0100, Konrad Rzeszutek Wilk wrote:
> > On Fri, Aug 19, 2011 at 02:26:33PM +0100, Ian Campbell wrote:
> > > The primary aim is to add skb_frag_(ref|unref) in order to remove the use of
> > > bare get/put_page on SKB pages fragments and to isolate users from subsequent
> > > changes to the skb_frag_t data structure.
> > > 
> > > Also included are helper APIs for passing a paged fragment to kmap and
> > > dma_map_page since I was seeing the same pattern a lot. A helper for
> > > pci_map_page is ommitted due to Michał Mirosław's recommendation that users
> > > should transition to pci_map_page instead.
> > 
> > You mean "transition to dma_map_page instead." ?
> 
> That's right, oops.

With a big pot of tea next to me to keep me sharp I took look at all
75 patches and besides this comment and the 'XXX' (which I already emailed
you about it - it also shows up in "36/75] myri10ge: convert to SKB paged frag API.")
they all looked OK to me.

So you can stick 'Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>'
on all of them if you would like.
