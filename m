Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2FGUtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:49:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086Ab2FGUtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:49:22 -0400
Date: Thu, 7 Jun 2012 22:49:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, acme@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: perf user tool precise attribute broken in 3.5rc1+
Message-ID: <20120607204915.GA1698@m.redhat.com>
References: <20120607202355.GQ27374@one.firstfloor.org>
 <CABPqkBSoCO4nSm==THVzVVu_cn=B5s4TZ_YpPxV73EGMNMgbrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBSoCO4nSm==THVzVVu_cn=B5s4TZ_YpPxV73EGMNMgbrg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 10:25:47PM +0200, Stephane Eranian wrote:
> What CPU model?
+1, latest tip works for me ;)

jirka

> 
> On Thu, Jun 7, 2012 at 10:23 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > With a perf user tool compiled from a 3.5rc1+ kernel I cannot
> > use the 'p' attribute anymore. Always get
> >
> > ak@petrock:~> ./perf record -e cycles:p ./t
> >
> >  Error: sys_perf_event_open() syscall returned with 22 (Invalid argument).  /bin/dmesg may provide additional information.
> >
> >  Fatal: No CONFIG_PERF_EVENTS=y kernel support configured?
> >
> > ./t: Terminated
> >
> > With an older perf it works, so the kernel is ok.
> >
> > ak@petrock:~> ./perf record -e cycles:p ./t
> > [ perf record: Woken up 1 times to write data ]
> > [ perf record: Captured and wrote 0.005 MB perf.data (~217 samples) ]
> > ak@petrock:~>
> >
> >
> > -Andi
> > --
> > ak@linux.intel.com -- Speaking for myself only.
