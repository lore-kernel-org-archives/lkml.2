Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab0C2Ky4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 06:54:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53217 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab0C2Kyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 06:54:54 -0400
Subject: Re: scheduler bug: process running since 5124095h
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <1269859960.6844.4.camel@marge.simson.net>
References: <4BADD408.8080609@gmail.com>  <4BAF1802.8070002@gmail.com>
	 <1269859960.6844.4.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 12:54:51 +0200
Message-ID: <1269860091.12097.303.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 12:52 +0200, Mike Galbraith wrote:
> > I have a simple way to reproduce this:
> > 1. Boot the system, run top, confirm everything is normal
> > 2. Run latencytop, and quit (I used version 0.5)
> > 3. Run top, see 5124095h in the TIME column
> 
> Indeed, and I don't even have CONFIG_LATENCYTOP set.  It bisected
> to...
> 
> 761b1d26df542fd5eb348837351e4d2f3bc7bffe is the first bad commit
> commit 761b1d26df542fd5eb348837351e4d2f3bc7bffe
> Author: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Date:   Thu Nov 12 13:33:45 2009 +0900


Oh lovely, and reverting that cures the issue?

