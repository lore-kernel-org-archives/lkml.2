Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab2C0Llx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 07:41:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:38750 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2C0Llt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 07:41:49 -0400
Date: Tue, 27 Mar 2012 14:43:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: array underflow in receive_SyncParam()?
Message-ID: <20120327114343.GB3200@mwanda>
References: <20120327071036.GA19008@elgon.mountain>
 <2865608.JOP40HBeUa@fat-tyre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2865608.JOP40HBeUa@fat-tyre>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090203.4F71A778.008D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 01:32:35PM +0200, Philipp Reisner wrote:
> Hi Dan,
> 
> You are right, we are relying on the fact that DRBD peers that
> use the protocol 88 send a positive data_size (what they do).
> 
> But if we consider a modified peer, then this is a bug. Suggesting
> the following patch:

Looks good to me.  Could you give me a Reported-by tag when you send
this?

regards,
dan carpenter

