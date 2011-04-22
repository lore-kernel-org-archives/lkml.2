Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab1DVUwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 16:52:42 -0400
Received: from smtpa1.mediabeam.com ([194.25.41.13]:4158 "EHLO
	smtpa1.mediabeam.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab1DVUwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 16:52:41 -0400
Date: Fri, 22 Apr 2011 22:52:35 +0200
From: Thomas Giesel <skoe@directbox.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: rt scheduler may calculate wrong rt_time
Message-ID: <20110422225235.30f89049@acer>
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

Mike,

> Hm.  Does forcing a clock update if we're idle when we release the
> throttle do the trick?

Thanks. I'm on holidays currently. I'll check it next week when I'm
back. But I think it should work in this way.

Thomas

