Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab2CEBl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 20:41:56 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:47546 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab2CEBlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 20:41:55 -0500
Date: Sun, 04 Mar 2012 20:41:47 -0500 (EST)
Message-Id: <20120304.204147.652134096643702602.davem@davemloft.net>
To: paulus@samba.org
Cc: netdev@vger.kernel.org, jan.kiszka@siemens.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix licensing problems in if_ppp.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120304225336.GA10646@bloggs.ozlabs.ibm.com>
References: <20120304225336.GA10646@bloggs.ozlabs.ibm.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 04 Mar 2012 17:41:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Mon, 5 Mar 2012 09:53:37 +1100

> This series of 3 patches is primarily aimed at removing the problem
> that the license on include/linux/if_ppp.h is the old BSD-style license
> with advertising clause.  However, in fact virtually none of that file
> comes from the original PPP code released by CMU.  This series solves
> the problem by moving the code that I originally wrote to a new header
> file with my copyright on it.
> 
> While we're at it, I also change the license on some files where I had
> put an ANU copyright notice originally to have my copyright instead.
> I have an acknowledgement in writing from September 2002 from ANU that
> they do not claim any copyright in this code.

All applied, thanks Paul.
