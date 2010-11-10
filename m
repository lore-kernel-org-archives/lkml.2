Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab0KJFvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 00:51:36 -0500
Received: from ozlabs.org ([203.10.76.45]:45593 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab0KJFvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 00:51:35 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Delegate unknown module parameters to interested parties
Date: Wed, 10 Nov 2010 16:21:28 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic-pae; KDE/4.5.1; i686; ; )
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
References: <0d30dc$k4dmjb@orsmga001.jf.intel.com> <1289311867-10096-1-git-send-email-chris@chris-wilson.co.uk> <1289313561.12418.96.camel@gandalf.stny.rr.com>
In-Reply-To: <1289313561.12418.96.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011101621.28946.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010 01:09:21 am Steven Rostedt wrote:
> [ Added Rusty "Module God" Russell ]

And I also wrote the parameter parsing code, so sending to me is probably
a good idea.

So, what's this for?  You want trace= as a standard module parameter
or something?  If this is a once-off I'd prefer a custom hack I think.
If you can think of other users, this might be a good idea; though don't
use "void *data" use an explicit struct module *...

Cheers,
Rusty.
