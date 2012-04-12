Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898Ab2DLWOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:14:34 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:42502 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166Ab2DLWOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:14:32 -0400
Date: Thu, 12 Apr 2012 18:12:56 -0400 (EDT)
Message-Id: <20120412.181256.1267592727086214582.davem@davemloft.net>
To: felipe.contreras@gmail.com
Cc: torvalds@linux-foundation.org, gregkh@linuxfoundation.org, lists@uece.net,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless@vger.kernel.org, c_manoha@qca.qualcomm.com,
        ath9k-devel@venema.h4ckr.net, linville@tuxdriver.com
Subject: Re: [ 00/78] 3.3.2-stable review
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMP44s0yPPqFUO4963MhNb8+c_A=xJi4-eFPJ3s+a1TJ8ZfTtQ@mail.gmail.com>
References: <CAMP44s14SQont1wyMeOuWcXUT3U5Tgnoj9mbbgOdVXY_hN0+-w@mail.gmail.com>
	<CA+55aFyLEJsz1yvu4bYe+RHdhLd-XXEScxtAgje=fyuUM+1XxA@mail.gmail.com>
	<CAMP44s0yPPqFUO4963MhNb8+c_A=xJi4-eFPJ3s+a1TJ8ZfTtQ@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 Apr 2012 15:13:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Contreras <felipe.contreras@gmail.com>
Date: Fri, 13 Apr 2012 01:04:42 +0300

> Wrong is wrong, before or after the 3.3.1 tag, this patch is not
> 'stable' material, and removing it does not affect upstream at all.

What you don't understand is that bug fixes will get lost if you only
fix them in -stable, it doesn't matter HOW THEY GOT into -stable.

In fact IT HAS FUCKING HAPPENED that we didn't fix something upstream
that got fixed in -stable a time long ago when we didn't have the
policy we're using now which you're going so unreasonably ape-shit
about.

And we didn't notice the discrepency until much later.

So the issues are real, there's proven precendence, and you're just
so wrong it's not even funny.

