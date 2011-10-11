Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab1JKCjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 22:39:46 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54440 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1JKCjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 22:39:45 -0400
Subject: Re: [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        John Kacur <jkacur@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, quilt-dev@nongnu.org
Date: Tue, 11 Oct 2011 04:39:40 +0200
In-Reply-To: <1318260925.7904.89.camel@gandalf.stny.rr.com>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
	 <20111004180237.GA15087@suse.de> <4E8B4BEC.5030708@zytor.com>
	 <1317757101.18063.24.camel@gandalf.stny.rr.com>
	 <4E8B6172.2050006@zytor.com>
	 <1317757696.18063.28.camel@gandalf.stny.rr.com>
	 <1317769149.1662.28.camel@schurl.linbit>
	 <1318260925.7904.89.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318300782.4248.51.camel@schurl.linbit>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 11:35 -0400, Steven Rostedt wrote:
> On Wed, 2011-10-05 at 00:58 +0200, Andreas Gruenbacher wrote:
> 
> > Yes, please.  Also please use Getopt::Long in the Perl script, and
> > send a patch relative to the quilt repo. I unfortunately can't help
> > with how to beat gpg into behaving right.
> 
> Where do I find the official quilt repo? Doing google searches only
> leads me to knitting sites. Which is actually quite helpful as the
> winter temperatures are coming around the corner.

It's a normal (non-)GNU Savannah project:

	git clone git://git.savannah.nongnu.org/quilt.git

Andreas

