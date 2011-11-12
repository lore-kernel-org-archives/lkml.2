Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1KLNE7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 08:04:59 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60236 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab1KLNE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 08:04:58 -0500
Date: Sat, 12 Nov 2011 22:04:49 +0900
From: =?utf-8?B?SsOpcsO0bWU=?= Pinot <ngc891@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: Evolution of kernel size
Message-ID: <20111112130449.GA10821@comet.deepsky.org>
References: <20111110143333.GA29457@comet.deepsky.org>
 <20111111165101.GA11227@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111111165101.GA11227@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/11 11:51, Ted Ts'o wrote:
> On Thu, Nov 10, 2011 at 11:33:33PM +0900, Jérôme Pinot wrote:
> > Hi,
> > 
> > I took some time to make a graph of the evolution of the size of the
> > linux kernel tar.bz2 since version 1.0 till 3.1 (297 releases).
> > It doesn't count the stable branches (2.6.x.y).
> 
> The question really is what are you trying to show with the graph, and
> what do you plan to use the graph for?  If it is estimating the size
> of disk space that you'll need at some point in the future, that's
> fine.  If it's for entertainment value, that's fine too.

That's exactly the point :-)

> But if it's to try to make some claims about (for example) kernel
> complexity, you'd do better to measure the size of various specific
> subsystems, such as mm, core kernel, a specific file system, etc.  And
> even then, the statistics can be misleading since sometimes
> refactoring to reduce complexity or removing unneeded abstraction
> layers can end up reducing the size of the subsystem, but leave it in
> a more maintainable state.

Measuring code complexity or work/cost of the source code was out of my
scope.

-- 
Jérôme Pinot
http://ngc891.blogdns.net/
