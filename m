Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab0DOXoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:44:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755843Ab0DOXo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:44:28 -0400
Date: Thu, 15 Apr 2010 16:42:16 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Zan Lynx <zlynx@acm.org>
Cc: Taras Glek <tglek@mozilla.com>, linux-kernel@vger.kernel.org
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
Message-Id: <20100415164216.26848906.akpm@linux-foundation.org>
In-Reply-To: <4BC79F75.2090704@acm.org>
References: <4BBA6776.5060804@mozilla.com>
	<20100415155309.2649a29b.akpm@linux-foundation.org>
	<4BC79F75.2090704@acm.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Apr 2010 17:21:25 -0600 Zan Lynx <zlynx@acm.org> wrote:

> On 4/15/10 4:53 PM, Andrew Morton wrote:
> 
> > This just isn't an interesting case.  World-wide, the number of people
> > who compile their own web browser and execute it from the file which ld
> > produced is, umm, seven.
> 
> Gentoo users? Linux From Scratch?
> 
> There are many more than 7 of us. Unless you are talking about the build 
> environments always running some tool after ld which I am not aware of.
> 

OK, eight then.

But I still don't think it's the case we should optimise for.  Not if
it impacts the common case even the slightest.  It'd be far far better
to change those distros to perform the very cheap, once-off step of
straightening out their executables (including shared libraries).

