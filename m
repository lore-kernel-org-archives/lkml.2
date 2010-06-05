Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab0FEJyP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 05:54:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46384
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932654Ab0FEJyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 05:54:13 -0400
Date: Sat, 05 Jun 2010 02:54:23 -0700 (PDT)
Message-Id: <20100605.025423.258132771.davem@davemloft.net>
To: jeffrey.t.kirsher@intel.com
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gospo@redhat.com,
       alexander.h.duyck@intel.com
Subject: Re: [net-next-2.6 PATCH 1/2] skbuff: add check for non-linear to
 warn_if_lro and needs_linearize
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100602222230.12962.97260.stgit@localhost.localdomain>
References: <20100602222230.12962.97260.stgit@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed, 02 Jun 2010 15:24:37 -0700

> From: Alexander Duyck <alexander.h.duyck@intel.com>
> 
> We can avoid an unecessary cache miss by checking if the skb is non-linear
> before accessing gso_size/gso_type in skb_warn_if_lro, the same can also be
> done to avoid a cache miss on nr_frags if data_len is 0.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

Applied.
