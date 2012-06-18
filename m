Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2FRG6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:58:00 -0400
Received: from ozlabs.org ([203.10.76.45]:44988 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab2FRG57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:57:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Borislav Petkov <bp@amd64.org>, Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org, pebolle@tiscali.nl, bp@amd64.org,
        pawel.moll@arm.com, jbaron@redhat.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH] init: add comments to keep initcall-names in sync with initcall levels
In-Reply-To: <20120615102906.GA6083@aftab.osrc.amd.com>
References: <1339711260-1349-1-git-send-email-jim.cromie@gmail.com> <20120615102906.GA6083@aftab.osrc.amd.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 18 Jun 2012 16:04:09 +0930
Message-ID: <87vcipyvq6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012 12:29:06 +0200, Borislav Petkov <bp@amd64.org> wrote:
> On Thu, Jun 14, 2012 at 04:00:59PM -0600, Jim Cromie wrote:
> > main.c has initcall_level_names[] for parse_args to print in debug messages,
> > add comments to keep them in sync with initcalls defined in init.h.
> > 
> > Also add "loadable" into comment re not using *_initcall macros in
> > modules, to disambiguate from kernel/params.c and other builtins.
> > 
> > Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> 
> This time I actually build-tested it.
> 
> Acked-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> Thanks.

Applied.

Thanks,
Rusty.
