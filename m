Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab1HXSVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:21:34 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51078 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab1HXSVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:21:33 -0400
Date: Wed, 24 Aug 2011 14:21:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH 01/75] net: add APIs for manipulating skb page fragments.
Message-ID: <20110824182113.GF15675@dumpdata.com>
References: <1313760393.5010.356.camel@zakaz.uk.xensource.com>
 <1313760467-8598-1-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1313760467-8598-1-git-send-email-ian.campbell@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E554126.0118:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 02:26:33PM +0100, Ian Campbell wrote:
> The primary aim is to add skb_frag_(ref|unref) in order to remove the use of
> bare get/put_page on SKB pages fragments and to isolate users from subsequent
> changes to the skb_frag_t data structure.
> 
> Also included are helper APIs for passing a paged fragment to kmap and
> dma_map_page since I was seeing the same pattern a lot. A helper for
> pci_map_page is ommitted due to Michał Mirosław's recommendation that users
> should transition to pci_map_page instead.

You mean "transition to dma_map_page instead." ?
