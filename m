Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2G0Uq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 16:46:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36699 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2G0Uq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 16:46:26 -0400
Date: Fri, 27 Jul 2012 13:46:26 -0700 (PDT)
Message-Id: <20120727.134626.1235770035400663747.davem@davemloft.net>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Subject: Re: [PATCH] of: drop of_pdt_build_more in pdt.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120727114009.GA5227@merkur.ravnborg.org>
References: <20120727114009.GA5227@merkur.ravnborg.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 27 Jul 2012 13:40:09 +0200

> From bc1fde5cacff425c4bddc061a72e52d3ecb9eeb2 Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Fri, 27 Jul 2012 13:34:54 +0200
> Subject: [PATCH] of: drop of_pdt_build_more in pdt.c
> 
> It is no longer used - as the sparc usage was dropped in:
> d884297acac228f15a793850be167ba8f9dd3818 -
> "sparc32,leon: drop leon_init()"
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Acked-by: David S. Miller <davem@davemloft.net>
