Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0CVDRM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 23:17:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59888
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753690Ab0CVDRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 23:17:10 -0400
Date: Sun, 21 Mar 2010 20:17:32 -0700 (PDT)
Message-Id: <20100321.201732.186318609.davem@davemloft.net>
To: mst@redhat.com
Cc: dlstevens@us.ibm.com, David.Woodhouse@intel.com,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netdev-owner@vger.kernel.org, paul.moore@hp.com,
       sri@linux.vnet.ibm.com
Subject: Re: [PATCH RFC] tun: add ioctl to modify vnet header size
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100317221117.GA7541@redhat.com>
References: <20100317213504.GA7433@redhat.com>
	<OFB24B6EEE.B788B01F-ON882576E9.00789167-882576E9.0079198A@us.ibm.com>
	<20100317221117.GA7541@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Thu, 18 Mar 2010 00:11:17 +0200

> All this does is set how much of the buffer to skip, this option does
> not allocate any memory.  So if you set it to a value > length that you
> passed in, you get -EINVAL. Anything else should work.  Negative values
> are checked for and return -EINVAL when you try to set it.  At least,
> all that's by design - pls take a look at the code and if you see any
> issues, speak up please.
> 
> I agree we don't really need to support very large values here,
> it just seemed less work.

This all looks fine to me, submit a final version to me via
whatever means you feel is appropriate.
