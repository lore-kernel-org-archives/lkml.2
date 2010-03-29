Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240Ab0C2LdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 07:33:21 -0400
Received: from mail.gmx.net ([213.165.64.20]:59010 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751045Ab0C2LdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 07:33:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+ehwIodX6eI7nXa/ls0lBQ2uLQuAPoSNG8e9ezQ3
	elM4obpKhnUoPN
Subject: Re: scheduler bug: process running since 5124095h
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <1269860091.12097.303.camel@laptop>
References: <4BADD408.8080609@gmail.com>  <4BAF1802.8070002@gmail.com>
	 <1269859960.6844.4.camel@marge.simson.net>
	 <1269860091.12097.303.camel@laptop>
Content-Type: text/plain
Date: Mon, 29 Mar 2010 13:33:16 +0200
Message-Id: <1269862396.24507.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 12:54 +0200, Peter Zijlstra wrote:
> On Mon, 2010-03-29 at 12:52 +0200, Mike Galbraith wrote:
> > > I have a simple way to reproduce this:
> > > 1. Boot the system, run top, confirm everything is normal
> > > 2. Run latencytop, and quit (I used version 0.5)
> > > 3. Run top, see 5124095h in the TIME column
> > 
> > Indeed, and I don't even have CONFIG_LATENCYTOP set.  It bisected
> > to...
> > 
> > 761b1d26df542fd5eb348837351e4d2f3bc7bffe is the first bad commit
> > commit 761b1d26df542fd5eb348837351e4d2f3bc7bffe
> > Author: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> > Date:   Thu Nov 12 13:33:45 2009 +0900
> 
> 
> Oh lovely, and reverting that cures the issue?

Haven't done so yet, will do later this afternoon.

	-Mike

