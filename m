Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab1CDVKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:10:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38260
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932503Ab1CDVKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:10:09 -0500
Date: Fri, 04 Mar 2011 13:10:46 -0800 (PST)
Message-Id: <20110304.131046.183062389.davem@davemloft.net>
To: ddaney@caviumnetworks.com
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH v2 12/12] staging: octeon_ethernet: Convert to use
 device tree.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1299267744-17278-13-git-send-email-ddaney@caviumnetworks.com>
References: <1299267744-17278-1-git-send-email-ddaney@caviumnetworks.com>
	<1299267744-17278-13-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <ddaney@caviumnetworks.com>
Date: Fri,  4 Mar 2011 11:42:24 -0800

> Get MAC address and PHY connection from the device tree.
> 
> Signed-off-by: David Daney <ddaney@caviumnetworks.com>

Acked-by: David S. Miller <davem@davemloft.net>
