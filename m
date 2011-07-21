Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1GURSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:18:24 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:42421 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab1GURSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:18:21 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] generic_hdlc: Update to current logging forms
References: <cover.1309150683.git.joe@perches.com>
	<d9186716ad410d64b1e09b39408a2f232f178260.1309150684.git.joe@perches.com>
Date: Thu, 21 Jul 2011 21:18:04 +0200
In-Reply-To: <d9186716ad410d64b1e09b39408a2f232f178260.1309150684.git.joe@perches.com>
	(Joe Perches's message of "Sun, 26 Jun 2011 22:01:28 -0700")
Message-ID: <m3d3h3e93n.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> Use pr_fmt, pr_<level> and netdev_<level> as appropriate.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/wan/c101.c       |   30 +++++++-------
>  drivers/net/wan/hd64570.c    |    8 ++--
>  drivers/net/wan/hd64572.c    |    8 ++--
>  drivers/net/wan/hdlc.c       |   16 ++++---
>  drivers/net/wan/hdlc_cisco.c |   21 ++++------
>  drivers/net/wan/hdlc_fr.c    |   96 +++++++++++++++++++-----------------------
>  drivers/net/wan/hdlc_ppp.c   |    9 ++--
>  drivers/net/wan/hdlc_x25.c   |   12 ++---
>  drivers/net/wan/n2.c         |   42 +++++++++---------
>  drivers/net/wan/pc300too.c   |   36 +++++++--------
>  drivers/net/wan/pci200syn.c  |   29 ++++++-------
>  drivers/net/wan/wanxl.c      |   90 ++++++++++++++++++---------------------

Looks good. I'll do some tests and then pass upstream. Thanks.
-- 
Krzysztof Halasa
