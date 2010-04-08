Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0DHEti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 00:49:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45227
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289Ab0DHEtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 00:49:35 -0400
Date: Wed, 07 Apr 2010 21:49:38 -0700 (PDT)
Message-Id: <20100407.214938.17608525.davem@davemloft.net>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, peppe.cavallaro@st.com
Subject: Re: [PATCH] stmmac: Fix incorrect resource calculation
From: David Miller <davem@davemloft.net>
In-Reply-To: <p2z427d64721004071828w41cedeb5j1079ed4cdd04fbf2@mail.gmail.com>
References: <p2z427d64721004071828w41cedeb5j1079ed4cdd04fbf2@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 8 Apr 2010 09:28:02 +0800

> The size calculation is not correct.  It should be end - start + 1.
> Use resource_size for {request/release}_mem_region and ioremap.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

A patch doing this was already submitted by Dan Carpenter to
the netdev list yesterday, and I will be applying his patch
right now.

And for future submissions, all networking patches should be at least
CC:'d to netdev.

Thanks.
