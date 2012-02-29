Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031231Ab2B2RQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:16:42 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:3778 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965496Ab2B2RQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:16:40 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <1330535788.25281.3.camel@lb-tlvb-dmitry>
Subject: Re: [PATCH 2/8] bnx2x: adopt bnx2x_validate_addr() to
 .ndo_validate_addr changes
From: "Dmitry Kravkov" <dmitry@broadcom.com>
To: "Danny Kukawka" <danny.kukawka@bisect.de>
cc: "Eilon Greenstein" <eilong@broadcom.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Date: Wed, 29 Feb 2012 19:16:28 +0200
In-Reply-To: <201202291808.30599.danny.kukawka@bisect.de>
References: <1330530176-24952-1-git-send-email-danny.kukawka@bisect.de>
 <1330530176-24952-3-git-send-email-danny.kukawka@bisect.de>
 <1330532535.25281.2.camel@lb-tlvb-dmitry>
 <201202291808.30599.danny.kukawka@bisect.de>
X-Mailer: Evolution 3.2.2-
MIME-Version: 1.0
X-WSS-ID: 6350800E50428931892-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 18:08 +0100, Danny Kukawka wrote:

> Do you mean something like this: 
> 
> int eth_validate_addr(struct net_device *dev, void *addr)
> {
>  u8 *vaddr;
> 
>  if (addr)
>     vaddr = ((struct sockaddr *) addr)->sa_data;
>  else
>     vaddr = dev->dev_addr;
> 
>  if (!is_valid_ether_addr(vaddr))
>     return -EADDRNOTAVAIL;
> 
>  return 0;
> }
> 
Exactly :)




