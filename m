Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125Ab2EXSmI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:42:08 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33545 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458Ab2EXSmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:42:04 -0400
Date: Thu, 24 May 2012 22:41:59 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>, ebiederm@xmission.com,
        tj@kernel.org, skinsbursky@openvz.org
Subject: Re: [rfc v2 0/7] procfs fdinfo extension v2
Message-ID: <20120524184159.GA26259@moon>
References: <20120523102541.382837149@openvz.org>
 <20120524180121.GK798@count0.beaverton.ibm.com>
 <20120524182347.GE23326@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524182347.GE23326@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 10:23:47PM +0400, Cyrill Gorcunov wrote:
> > 
> > As best I can tell your reply last time only fleshed out the details
> > of *how* you would like it to work, not *why it needs to* work that way:
> > 
> > 	http://lkml.org/lkml/2011/11/30/27

Matt, as to "why it needs to work that way" -- this approach will simply
work well without a need to patch mainline kernel much, since almost everything
needed for transparent restore already in kernel except "ptrace with frozen cgroup",
(we even restore without frozen cgroup but with a couple of nasty tricks in crtools
utility now). But if there some other approach which we've missed, I would
really appreciate if you share it.

	Cyrill
