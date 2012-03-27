Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab2C0Fzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 01:55:32 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38254 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab2C0Fza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 01:55:30 -0400
Date: Tue, 27 Mar 2012 01:53:16 -0400 (EDT)
Message-Id: <20120327.015316.1552473998755517441.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: gregkh@linuxfoundation.org, key@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] powerpc+sparc/vio: Modernize driver registration
From: David Miller <davem@davemloft.net>
In-Reply-To: <1332824790.2882.51.camel@pasglop>
References: <1332824790.2882.51.camel@pasglop>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 26 Mar 2012 22:53:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 27 Mar 2012 16:06:30 +1100

> This makes vio_register_driver() get the module owner & name at compile
> time like PCI drivers do, and adds a name pointer directly in struct
> vio_driver to avoid having to explicitly initialize the embedded
> struct device.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Acked-by: David S. Miller <davem@davemloft.net>
