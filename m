Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab2GYQME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:12:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56869 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab2GYQMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:12:00 -0400
Date: Wed, 25 Jul 2012 18:11:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 03/17] perf, x86: Add copy_from_user_nmi_nochk for best
 effort copy
Message-ID: <20120725161150.GA1173@somewhere.redhat.com>
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
 <1342959280-5361-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342959280-5361-4-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 02:14:26PM +0200, Jiri Olsa wrote:
> Adding copy_from_user_nmi_nochk that provides the best effort
> copy regardless the requesting size crossing the task boundary.
> 
> This is going to be useful for stack dump we need in post
> DWARF CFI based unwind, where we have predefined size of
> the user stack to dump, and we need to store the most of
> the requested dump size, regardless this size is crossing
> the task boundary.

What does that imply when we cross this limit? Are we still in the
task stack?
