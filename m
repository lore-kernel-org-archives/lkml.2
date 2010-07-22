Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab0GVF25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 01:28:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51079
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754836Ab0GVF20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 01:28:26 -0400
Date: Wed, 21 Jul 2010 22:28:42 -0700 (PDT)
Message-Id: <20100721.222842.155365075.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, benh@kernel.crashing.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        microblaze-uclinux@itee.uq.edu.au, sparclinux@vger.kernel.org
Subject: Re: [PATCH 4/5] of: remove asm/of_platform.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100721234010.7782.3073.stgit@angua>
References: <20100721232817.7782.23410.stgit@angua>
	<20100721234010.7782.3073.stgit@angua>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 21 Jul 2010 17:40:10 -0600

> Only thing left in it is of_instantiate_rtc() which can be moved to
> asm/prom.h on PowerPC and is unused in microblaze.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: David S. Miller <davem@davemloft.net>
