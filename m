Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab2F2HjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 03:39:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab2F2HjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 03:39:04 -0400
Date: Fri, 29 Jun 2012 09:38:04 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCH 04/23] perf, x86: Add copy_from_user_nmi_nochk for best
 effort copy
Message-ID: <20120629073804.GC940@krava.brq.redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
 <1340120894-9465-5-git-send-email-jolsa@redhat.com>
 <20120627151903.GH20638@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627151903.GH20638@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 05:19:06PM +0200, Frederic Weisbecker wrote:
> On Tue, Jun 19, 2012 at 05:47:55PM +0200, Jiri Olsa wrote:
> > Adding copy_from_user_nmi_nochk that provides the best effort
> > copy regardless the size crossing the task boundary at the moment.
> 
> The changelog needs more info about this. Why are we removing this check?
> 

ok

> > 
> > This is going to be useful for stack dump we need in post
> > DWARF CFI based unwind.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
