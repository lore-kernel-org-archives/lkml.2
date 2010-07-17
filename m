Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727Ab0GQJVI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 05:21:08 -0400
Received: from khc.piap.pl ([195.187.100.11]:49058 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab0GQJVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 05:21:06 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-kernel@vger.kernel.org, Dan Nicolaescu <dann@gnu.org>
Subject: Re: emacs and "linux" coding style
References: <alpine.LNX.2.00.1007131644180.1500@localhost.localdomain>
Date: Sat, 17 Jul 2010 11:21:03 +0200
In-Reply-To: <alpine.LNX.2.00.1007131644180.1500@localhost.localdomain>
	(Dimitrios Apostolou's message of "Tue, 13 Jul 2010 17:00:21 +0300
	(EEST)")
Message-ID: <m3tyny31mo.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitrios Apostolou <jimis@gmx.net> writes:

> static void update_group_shares_cpu(struct task_group *tg, int cpu,
>                                     unsigned long sd_shares,
>                                     unsigned long sd_rq_weight,
>                                     unsigned long *usd_rq_weight)
> {

>From a technical POV the above should not have any tabs, the parameters
should be aligned with spaces only.

The tabs should be used for (syntactic) indentation only.

This way we can display the code correctly with any tab length.
-- 
Krzysztof Halasa
