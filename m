Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab1GDDFe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 23:05:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43514 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab1GDDFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 23:05:32 -0400
Date: Sun, 03 Jul 2011 20:05:27 -0700 (PDT)
Message-Id: <20110703.200527.2004595152778358649.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, philb@gnu.org
Subject: Re: [PATCH] af_econet: Use current logging styles and neatening
From: David Miller <davem@davemloft.net>
In-Reply-To: <8e47a6e010a39bd35d3544311dd451abda8b7fb3.1309717580.git.joe@perches.com>
References: <8e47a6e010a39bd35d3544311dd451abda8b7fb3.1309717580.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 03 Jul 2011 20:05:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sun,  3 Jul 2011 11:28:33 -0700

> Use pr_fmt() without KBUILD_MODNAME to allow AUN and econet prefixes.
> Convert printks with KERN_DEBUG to pr_debug.
> Hoist assigns from if.
> 80 column wrapping.
> Move open braces to end of line.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.
