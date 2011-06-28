Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab1F1FQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 01:16:28 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:41873 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab1F1FOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 01:14:47 -0400
Date: Mon, 27 Jun 2011 22:12:57 -0700 (PDT)
Message-Id: <20110627.221257.1290251511587162468.davem@davemloft.net>
To: ralf@linux-mips.org
Cc: akpm@linux-foundation.org, alan@linux.intel.com, bcasavan@sgi.com,
        airlied@linux.ie, grundler@parisc-linux.org, JBottomley@parallels.com,
        perex@perex.cz, rpurdie@rpsys.net, klassert@mathematik.tu-chemnitz.de,
        tj@kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/12] Fix various section mismatches and build errors.
From: David Miller <davem@davemloft.net>
In-Reply-To: <17dd5038b15d7135791aadbe80464a13c80758d3.1309182742.git.ralf@linux-mips.org>
References: <17dd5038b15d7135791aadbe80464a13c80758d3.1309182742.git.ralf@linux-mips.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 27 Jun 2011 22:13:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


See commit:

commit 948252cb9e01d65a89ecadf67be5018351eee15e
Author: David S. Miller <davem@davemloft.net>
Date:   Tue May 31 19:27:48 2011 -0700

    Revert "net: fix section mismatches"
    
    This reverts commit e5cb966c0838e4da43a3b0751bdcac7fe719f7b4.
    
    It causes new build regressions with gcc-4.2 which is
    pretty common on non-x86 platforms.
    
    Reported-by: James Bottomley <James.Bottomley@HansenPartnership.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

and postings that led to this revert including:

http://marc.info/?l=linux-netdev&m=130653748205263&w=2
