Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab0CQPvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:51:51 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:57959 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab0CQPvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:51:49 -0400
Date: Wed, 17 Mar 2010 16:51:28 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 42/66] arch/mips/lib/libgcc.h: Checkpatch cleanup
Message-ID: <20100317155126.GE4554@linux-mips.org>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
 <1267289508-31031-43-git-send-email-andrea.gelmini@gelma.net>
 <20100301023316.GB23086@linux-sh.org>
 <9cdbb57f1003020713x4e897af9ka87e348bf782f380@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cdbb57f1003020713x4e897af9ka87e348bf782f380@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 04:13:11PM +0100, Andrea Gelmini wrote:

> 2010/3/1 Paul Mundt <lethal@linux-sh.org>:
> Hi Paul,
>    thanks for your reply.
> 
> > I'll apply the sh part by itself, and I suppose Ralf will do the same for
> > MIPS. I'm a bit confused as to why these were lumped together when 65 out
> > of 66 oneliner patches made no use of ad-hoc grouping.
> 
> After the experience with GregKH, I was looking for others maintainer
> interested in code cleanup. So I sent some patches over random files.
> If you care, I can checkpatch.pl all mips subtree and send you patches (if any).

Feel free to - but remember that the coding style document is a guideline
not something to be followed unconditionally.

  Ralf
