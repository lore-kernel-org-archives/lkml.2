Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab2JBI4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:56:53 -0400
Received: from smtp.getmail.no ([84.208.15.66]:42745 "EHLO smtp.getmail.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab2JBI4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:56:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
In-reply-to: <1349064397.6957.26.camel@marge.simpson.net>
References: <op.wlf5j0i76426ze@localhost.localdomain>
 <1349064397.6957.26.camel@marge.simpson.net>
Subject: Re: The 10ms averager in fair.c
To: Mike Galbraith <efault@gmx.de>
Date: Tue, 02 Oct 2012 08:56:48 +0200
From: Uwaysi Bin Kareem <uwaysi.bin.kareem@paradoxuncreated.com>
Message-id: <op.wljhky1q6426ze@millennium.getinternet.no>
User-Agent: Opera Mail/12.02 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just too much code for me to do a quick patch on. It really needs  
to be evaulated with concerns to what an optimal scheduler is. That would  
be to operate on actual system load ofcourse, not a filtered system load  
that doesn`t represent what is actually happening on a computer.

What you can do for the time being is just set it to 1nS. If that doesn`t  
negatively impact anything, then you know it is bogus.

Peace Be With You.
