Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab1JYTpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 15:45:24 -0400
Received: from tex.lwn.net ([70.33.254.29]:36453 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab1JYTpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 15:45:23 -0400
Date: Tue, 25 Oct 2011 13:48:00 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Please re-enable the git-commits-head mailing list
Message-ID: <20111025134800.4da48376@tpl.lwn.net>
In-Reply-To: <4EA6EA6F.1020602@panasas.com>
References: <4EA6EA6F.1020602@panasas.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011 09:57:19 -0700
Boaz Harrosh <bharrosh@panasas.com> wrote:

> Since the brain stroke of vger.kernel.org we stopped getting any messages on
> git-commits-head@vger.kernel.org It is important because of the mirroring delay of the gits which
> can take 24 h in some places. And because it is a very convenient way to look for something or in
> general keep track of what's going on.
> 
> Please re-enable it. It should be as simple as:
> 	git config --add hooks.mailinglist "git-commits-head@vger.kernel.org"

The commits list was discussed at the kernel summit.  The people who
are working to piece kernel.org together are aware of the value of this
list and will arrange for it when they can.  As I understand it, the
first priority remains getting the git trees back onto kernel.org to
support the merge window, though.

jon
