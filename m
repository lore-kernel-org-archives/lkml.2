Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab1KKQvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:51:07 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:45804 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab1KKQvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:51:05 -0500
Date: Fri, 11 Nov 2011 11:51:01 -0500
From: "Ted Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?B?Suly9G1l?= Pinot <ngc891@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Evolution of kernel size
Message-ID: <20111111165101.GA11227@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	=?iso-8859-1?B?Suly9G1l?= Pinot <ngc891@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20111110143333.GA29457@comet.deepsky.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111110143333.GA29457@comet.deepsky.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 11:33:33PM +0900, Jérôme Pinot wrote:
> Hi,
> 
> I took some time to make a graph of the evolution of the size of the
> linux kernel tar.bz2 since version 1.0 till 3.1 (297 releases).
> It doesn't count the stable branches (2.6.x.y).

The question really is what are you trying to show with the graph, and
what do you plan to use the graph for?  If it is estimating the size
of disk space that you'll need at some point in the future, that's
fine.  If it's for entertainment value, that's fine too.

But if it's to try to make some claims about (for example) kernel
complexity, you'd do better to measure the size of various specific
subsystems, such as mm, core kernel, a specific file system, etc.  And
even then, the statistics can be misleading since sometimes
refactoring to reduce complexity or removing unneeded abstraction
layers can end up reducing the size of the subsystem, but leave it in
a more maintainable state.

						- Ted
