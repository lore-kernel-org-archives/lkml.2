Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775Ab1D0RvV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:51:21 -0400
Received: from smtpa1.mediabeam.com ([194.25.41.13]:41353 "EHLO
	smtpa1.mediabeam.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759748Ab1D0RvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:51:19 -0400
Date: Wed, 27 Apr 2011 19:51:13 +0200
From: Thomas Giesel <skoe@directbox.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: rt scheduler may calculate wrong rt_time
Message-ID: <20110427195113.4e0064bb@acer>
In-Reply-To: <1303460491.28545.12.camel@marge.simson.net>
References: <20110421145510.28cb7b78@skoe.de>
	<1303460491.28545.12.camel@marge.simson.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hm.  Does forcing a clock update if we're idle when we release the
> throttle do the trick?

It does. I tested it today and it works as expected. Even with ftrace I
couldn't see any suspicious behaviour anymore.

Mike: Can you send the patch to the right people to get it into the
kernel or should I do it? Or is Peter the right one already?

Thanks for your help.

Thomas


