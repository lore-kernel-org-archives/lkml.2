Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2DBDKF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 23:10:05 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:47019 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab2DBDKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 23:10:01 -0400
Date: Sun, 01 Apr 2012 23:07:25 -0400 (EDT)
Message-Id: <20120401.230725.2062070470189882316.davem@davemloft.net>
To: eldad@fogrefinery.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] net/ipv6/exthdrs.c: Checkpatch cleanups
From: David Miller <davem@davemloft.net>
In-Reply-To: <1333302548-9187-4-git-send-email-eldad@fogrefinery.com>
References: <1333302548-9187-1-git-send-email-eldad@fogrefinery.com>
	<1333302548-9187-4-git-send-email-eldad@fogrefinery.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 01 Apr 2012 20:07:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eldad Zack <eldad@fogrefinery.com>
Date: Sun,  1 Apr 2012 19:49:04 +0200

> exthdrs.c:726: WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> exthdrs.c:741: ERROR: "(foo*)" should be "(foo *)"
> exthdrs.c:741: ERROR: "(foo*)" should be "(foo *)"
> exthdrs.c:744: ERROR: "(foo**)" should be "(foo **)"
> exthdrs.c:746: ERROR: "(foo**)" should be "(foo **)"
> exthdrs.c:748: ERROR: "(foo**)" should be "(foo **)"
> exthdrs.c:750: ERROR: "(foo**)" should be "(foo **)"
> exthdrs.c:755: WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> exthdrs.c:896: WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
> 
> Signed-off-by: Eldad Zack <eldad@fogrefinery.com>

Applied.
