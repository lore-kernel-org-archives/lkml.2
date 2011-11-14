Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab1KNFb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 00:31:28 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:46082 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab1KNFb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 00:31:26 -0500
Date: Mon, 14 Nov 2011 00:31:13 -0500 (EST)
Message-Id: <20111114.003113.40819474361221233.davem@davemloft.net>
To: mjg@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jcliburn@gmail.com,
        chris.snook@gmail.com
Subject: Re: [PATCH V2 2/6] net/ethernet/atl1e: Disable ASPM
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321028064-644-3-git-send-email-mjg@redhat.com>
References: <1321028064-644-1-git-send-email-mjg@redhat.com>
	<1321028064-644-3-git-send-email-mjg@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 13 Nov 2011 21:31:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>
Date: Fri, 11 Nov 2011 11:14:20 -0500

> http://www.atheros.cz/atheros-inf-file.php?inf=209&chipset=45&system=6
> indicates that ASPM is disabled on all L1E hardware. Duplicate for sanity.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Applied.
