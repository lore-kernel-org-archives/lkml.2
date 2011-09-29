Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758086Ab1I2XgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:36:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53424 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab1I2XgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:36:20 -0400
Date: Thu, 29 Sep 2011 19:31:57 -0400 (EDT)
Message-Id: <20110929.193157.1260100265703479487.davem@davemloft.net>
To: jeremy@goop.org
Cc: rostedt@goodmis.org, david.daney@cavium.com, michael@ellerman.id.au,
        jang@linux.vnet.ibm.com, jbaron@redhat.com, x86@kernel.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        jeremy.fitzhardinge@citrix.com
Subject: Re: [PATCH RFC 4/8] sparc/jump_label: add
 arch_jump_label_transform_early()
From: David Miller <davem@davemloft.net>
In-Reply-To: <6b0e55538e91fd7663430a291a39c6ed048b2548.1317338254.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
	<cover.1317338254.git.jeremy.fitzhardinge@citrix.com>
	<6b0e55538e91fd7663430a291a39c6ed048b2548.1317338254.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 29 Sep 2011 16:32:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Thu, 29 Sep 2011 16:26:34 -0700

> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> This allows jump-label entries to be modified early, in a pre-SMP
> environment.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Acked-by: David S. Miller <davem@davemloft.net>
