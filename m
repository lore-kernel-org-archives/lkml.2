Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab2GYQgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:36:35 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:52672 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab2GYQgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:36:33 -0400
Date: Wed, 25 Jul 2012 18:36:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 06/17] perf: Add ability to attach user stack dump to
 sample
Message-ID: <20120725163626.GD1173@somewhere.redhat.com>
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
 <1342959280-5361-7-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342959280-5361-7-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 02:14:29PM +0200, Jiri Olsa wrote:
> Introducing PERF_SAMPLE_STACK_USER sample type bit to trigger
> the dump of the user level stack on sample. The size of the
> dump is specified by sample_stack_user value.
> 
> Being able to dump parts of the user stack, starting from the
> stack pointer, will be useful to make a post mortem dwarf CFI
> based stack unwinding.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

If you keep the SOB of the author then you need to preserve its
authorship (git am --author= / git commit --amend --author=).
Unless you changed the patch significantly enough that you
simply credit with something like "Original-patch-by" and you become the
author. This is left to personal appreciation, I won't mind
in any case.

But there is no middle ground :)
You also need to keep the SOB chain in order. The above SOB chain
suggests I'm carrying a patch from you.

Just saying that so that you make the maintainers job easier ;)
