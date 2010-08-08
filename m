Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab0HHTPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 15:15:19 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1877 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633Ab0HHTPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 15:15:17 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: [PATCH 32/42] drivers/net/bnx2x: Adjust confusing if
 indentation
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "Dan Carpenter" <error27@gmail.com>
cc: "Julia Lawall" <julia@diku.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        yanivr@broadcom.com
In-Reply-To: <20100806070749.GP9031@bicker>
References: <Pine.LNX.4.64.1008052226210.31692@ask.diku.dk>
 <20100806070749.GP9031@bicker>
Organization: Broadcom
Date: Sun, 8 Aug 2010 22:14:53 +0300
Message-ID: <1281294893.21680.5.camel@lb-tlvb-eilong.il.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3
X-WSS-ID: 6041DDBD3KC69703802-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 00:07 -0700, Dan Carpenter wrote:
> On Thu, Aug 05, 2010 at 10:26:38PM +0200, Julia Lawall wrote:
> > ---
> > This patch doesn't change the semantics of the code.  But it might not be
> > what is intended.
> > 
> 
> I think there may have been some if statements which were removed before
> the code was merged into the kernel?  Here is another one from that same
> function.  Someone can roll this in with your patch.
> 

Thanks Dan. We will send a more complete patch series for this file once
net-next is open again.


