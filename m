Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab2DCGjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 02:39:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59362 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2DCGjS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 02:39:18 -0400
Date: Tue, 03 Apr 2012 02:38:13 -0400 (EDT)
Message-Id: <20120403.023813.1884403672741100061.davem@davemloft.net>
To: remi@remlab.net
Cc: levinsasha928@gmail.com, davej@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phonet: Check input from user before allocating
From: David Miller <davem@davemloft.net>
In-Reply-To: <dc6e3bc8b96d91bd7ce44639b60cfec2@chewa.net>
References: <201204022201.41808.remi@remlab.net>
	<20120402.174006.70116829696492189.davem@davemloft.net>
	<dc6e3bc8b96d91bd7ce44639b60cfec2@chewa.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 02 Apr 2012 23:38:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rémi Denis-Courmont <remi@remlab.net>
Date: Tue, 03 Apr 2012 08:36:20 +0200

> Oh right. And Phonet devices don't support scatter/gather, so that I
> guess that would merely delay the problem.

And this lack of SG support in the drivers never materialized largely
because the phonet stack never generated such things.

So yes indeed both sides of this equation will need to be addressed.
