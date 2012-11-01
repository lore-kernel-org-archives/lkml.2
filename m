Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761372Ab2KALZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 07:25:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab2KALZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:25:41 -0400
Date: Thu, 1 Nov 2012 07:25:36 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MODSIGN: Add modules_sign make target
Message-ID: <20121101112535.GL6627@hansolo.jdub.homelinux.org>
References: <20121031135605.GJ6627@hansolo.jdub.homelinux.org>
 <87zk314w1t.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zk314w1t.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 06:03:18PM +1030, Rusty Russell wrote:
> Josh Boyer <jwboyer@redhat.com> writes:
> 
> > If CONFIG_MODULE_SIG is set, and 'make modules_sign' is called then this
> > patch will cause the modules to get a signature appended.  The make target
> > is intended to be run after 'make modules_install', and will modify the
> > modules in-place in the installed location.  It can be used to produce
> > signed modules after they have been processed by distribution build
> > scripts.
> >
> > Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> 
> It's a bit of a niche case, but applied.

Thanks.  Whether you consider RPM built kernels niche or not doesn't
matter to me.  Having this upstream is one less patch we have to carry
so I appreciate it a lot.

josh
