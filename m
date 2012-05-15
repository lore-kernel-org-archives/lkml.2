Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965965Ab2EOROx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:14:53 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40280 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815Ab2EOROv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:14:51 -0400
Date: Tue, 15 May 2012 13:14:36 -0400 (EDT)
Message-Id: <20120515.131436.1766404788147122977.davem@davemloft.net>
To: JBeulich@suse.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, v2] xfrm: make xfrm_algo.c a module
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FB260D80200007800083C91@nat28.tlf.novell.com>
References: <4FB260D80200007800083C91@nat28.tlf.novell.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 15 May 2012 10:14:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jan Beulich" <JBeulich@suse.com>
Date: Tue, 15 May 2012 12:57:44 +0100

> By making this a standalone config option (auto-selected as needed),
> selecting CRYPTO from here rather than from XFRM (which is boolean)
> allows the core crypto code to become a module again even when XFRM=y.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>

Applied.
