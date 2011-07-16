Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab1GPVBk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 17:01:40 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:47010 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755397Ab1GPVBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 17:01:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sWtEvS1zZWiwxa9D1cy+IoR6CSJlxS7SwLxlNSt5sfu5Qzmg841ZBpj3xD37Ad6DeOSuzBXkySh75kfPKH0+ZOzaqLZMrVRxSPVRopq2xMbq/pxWJzLxJD4mjGXMgJcx;
Date: Sat, 16 Jul 2011 14:01:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: dmitry@broadcom.com
Cc: "David Miller" <davem@davemloft.net>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eilon Greenstein" <eilong@broadcom.com>
Subject: Re: linux-next: Tree for July 16 (net/bnx2x)
Message-Id: <20110716140135.b471aa27.rdunlap@xenotime.net>
In-Reply-To: <1310848256.2826.3.camel@lb-tlvb-dmitry>
References: <20110717000815.c83755be9598d34ac8431908@canb.auug.org.au>
	<20110716121427.11760128.rdunlap@xenotime.net>
	<1310847842.2826.1.camel@lb-tlvb-dmitry>
	<20110716.132643.101780166611692580.davem@davemloft.net>
	<1310848256.2826.3.camel@lb-tlvb-dmitry>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jul 2011 23:30:56 +0300 Dmitry Kravkov wrote:

> On Sat, 2011-07-16 at 13:26 -0700, David Miller wrote:
> > From: "Dmitry Kravkov" <dmitry@broadcom.com>
> > Date: Sat, 16 Jul 2011 23:24:02 +0300
> > 
> > > @@ -1403,8 +1403,8 @@ void bnx2x_netif_stop(struct bnx2x *bp, int
> > > disable_hw)
> > >  
> > 
> > Patch corrupted by your email client, this long line was chopped
> > up into two lines.
> > 
> bnx2x: Fix compilation when CNIC is not selected in config
> 
> Reported-by:  Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Dmitry Kravkov <dmitry@broadcom.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/net/bnx2x/bnx2x_cmn.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/bnx2x/bnx2x_cmn.c b/drivers/net/bnx2x/bnx2x_cmn.c
> index e5fac62..b05ce93 100644
> --- a/drivers/net/bnx2x/bnx2x_cmn.c
> +++ b/drivers/net/bnx2x/bnx2x_cmn.c
> @@ -1403,8 +1403,8 @@ void bnx2x_netif_stop(struct bnx2x *bp, int disable_hw)
>  
>  u16 bnx2x_select_queue(struct net_device *dev, struct sk_buff *skb)
>  {
> -#ifdef BCM_CNIC
>  	struct bnx2x *bp = netdev_priv(dev);
> +#ifdef BCM_CNIC
>  	if (NO_FCOE(bp))
>  		return skb_tx_hash(dev, skb);
>  	else {
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
