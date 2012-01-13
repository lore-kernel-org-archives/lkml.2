Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228Ab2AMVWC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 16:22:02 -0500
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:39926 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759191Ab2AMVV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 16:21:58 -0500
Date: Fri, 13 Jan 2012 19:21:48 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: roland@purestorage.com, venkat.x.venkatsubra@oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dledford@redhat.com, Jes.Sorensen@redhat.com, rds-devel@oss.oracle.com
Subject: Re: [PATCH] rds_rdma: don't assume infiniband device is PCI
Message-ID: <20120113212148.GD3904@oc1711230544.ibm.com>
References: <20120113181706.GA3904@oc1711230544.ibm.com>
 <20120113.102518.924916400773191073.davem@davemloft.net>
 <20120113185258.GB3904@oc1711230544.ibm.com>
 <20120113.131248.447541680022014759.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120113.131248.447541680022014759.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12011321-2362-0000-0000-0000060114A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 01:12:48PM -0800, David Miller wrote:
> From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
> Date: Fri, 13 Jan 2012 16:52:58 -0200
> 
> > On Fri, Jan 13, 2012 at 10:25:18AM -0800, David Miller wrote:
> >> From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
> >> Date: Fri, 13 Jan 2012 16:17:06 -0200
> >> 
> >> > Is this going through your tree? In patchwork, its state is "Not
> >> > Applicable".
> >> 
> >> There was an active RDS maintainer, though I haven't seen patches
> >> from that person in a while.
> >> 
> > 
> > Hi, David.
> > 
> > Venkat is the current RDS maintainer and he has Acked the patch.
> 
> Not according to patchwork.  I don't see him reply at all to the
> patch posting and give his explicit "Acked-by: "
> 

Venkat,

Care to send an Acked-by using a different MUA? Yours sends no
In-Reply-To or References header field.

David,

This is the message Venkat has sent.

http://marc.info/?l=linux-netdev&m=132587819932339&w=2

Thanks.
Cascardo.

