Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab0ICCQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 22:16:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54485
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753503Ab0ICCQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 22:16:31 -0400
Date: Thu, 02 Sep 2010 19:16:47 -0700 (PDT)
Message-Id: <20100902.191647.258116956.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, peppe.cavallaro@st.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100903115226.52d0ccb3.sfr@canb.auug.org.au>
References: <20100903114750.3d8994b7.sfr@canb.auug.org.au>
	<20100903115226.52d0ccb3.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 3 Sep 2010 11:52:26 +1000

> Hi all,
> 
> On Fri, 3 Sep 2010 11:47:50 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> Exposed by commit ac75791aa943c7953521cb4fa7728bf51f9abd2d ("stmmac:
>> remove dead option in the driver's Kconfig")  That allowed the driver to
>> be built on a lot more platforms that previously.
> 
> That commit was the result of the only platform that this driver was ever
> used on being removed by commit f96691872439ab2071171d4531c4a95b5d493ae5
> ("sh: Kill off the remaining ST40 cruft").  So maybe this driver should
> actually be removed from the tree as well?

That's up to whoever maintains this thing, well... there is no listed
maintainer in MAINTAINERS.
