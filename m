Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1HXVJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:09:05 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:52309 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab1HXVJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:09:04 -0400
X-IronPort-AV: E=Sophos;i="4.68,277,1312156800"; 
   d="scan'208";a="7431142"
Subject: Re: [PATCH 01/75] net: add APIs for manipulating skb page
 fragments.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
In-Reply-To: <20110824182113.GF15675@dumpdata.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
	 <1313760467-8598-1-git-send-email-ian.campbell@citrix.com>
	 <20110824182113.GF15675@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 24 Aug 2011 22:09:01 +0100
Message-ID: <1314220141.17978.693.camel@dagon.hellion.org.uk>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 19:21 +0100, Konrad Rzeszutek Wilk wrote:
> On Fri, Aug 19, 2011 at 02:26:33PM +0100, Ian Campbell wrote:
> > The primary aim is to add skb_frag_(ref|unref) in order to remove the use of
> > bare get/put_page on SKB pages fragments and to isolate users from subsequent
> > changes to the skb_frag_t data structure.
> > 
> > Also included are helper APIs for passing a paged fragment to kmap and
> > dma_map_page since I was seeing the same pattern a lot. A helper for
> > pci_map_page is ommitted due to Michał Mirosław's recommendation that users
> > should transition to pci_map_page instead.
> 
> You mean "transition to dma_map_page instead." ?

That's right, oops.

Ian.


