Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab2HAI5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 04:57:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57725 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab2HAI5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 04:57:46 -0400
Date: Wed, 1 Aug 2012 10:57:12 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Subject: Re: [PATCHv8 00/13] perf: Add backtrace post dwarf unwind
Message-ID: <20120801085712.GA2528@krava.brq.redhat.com>
References: <1343391834-10851-1-git-send-email-jolsa@redhat.com>
 <CABPqkBRRn4f00qCr+p4fh3L7SXqOBHi3CB4TJbjzSxexWRmYRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRRn4f00qCr+p4fh3L7SXqOBHi3CB4TJbjzSxexWRmYRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 06:04:31AM +0200, Stephane Eranian wrote:
> On Fri, Jul 27, 2012 at 2:23 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > hi,
> > patches available also as tarball in here:
> > http://people.redhat.com/~jolsa/perf_post_unwind_v8.tar.bz2
> >
> > v8 changes:
> >    - patch 2 - added dump registers ABI specification as suggested
> >                by Stephane
> >    - v7 patches 9,10,16,17 already in
> >
> Patches 4, 7 do not apply cleanly for me on tip-master @ commit 2a7d7ce
> when I use the tarball version of the patchset.

there's conflict with fresh commit..

perf/trace: Add ability to set a target task for events
commit e6dab5ffab59e910ec0e3355f4a6f29f7a7be474
Author: Andrew Vagin <avagin@openvz.org>
Date:   Wed Jul 11 18:14:58 2012 +0400

I'm testing v9 and will send it out shortly

thanks,
jirka
