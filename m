Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab2FGVS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 17:18:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757195Ab2FGVS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 17:18:57 -0400
Date: Thu, 7 Jun 2012 23:18:51 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@google.com>, acme@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: perf user tool precise attribute broken in 3.5rc1+
Message-ID: <20120607211851.GB1698@m.redhat.com>
References: <20120607202355.GQ27374@one.firstfloor.org>
 <CABPqkBSoCO4nSm==THVzVVu_cn=B5s4TZ_YpPxV73EGMNMgbrg@mail.gmail.com>
 <20120607204915.GA1698@m.redhat.com>
 <20120607205722.GS27374@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607205722.GS27374@one.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 10:57:22PM +0200, Andi Kleen wrote:
> On Thu, Jun 07, 2012 at 10:49:15PM +0200, Jiri Olsa wrote:
> > On Thu, Jun 07, 2012 at 10:25:47PM +0200, Stephane Eranian wrote:
> > > What CPU model?
> > +1, latest tip works for me ;)
> 
> how about mainline?
> 
> -Andi

yes..

jirka

---
[jolsa@dhcp-26-214 perf]$ ./perf record -e cycles:p date
Thu Jun  7 23:33:02 CEST 2012
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.006 MB perf.data (~260 samples) ]
[jolsa@dhcp-26-214 perf]$ git show
commit 513335f964a17bd99a699b939391eb111aa5f65b
Merge: 0c30989 4c01acc
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jun 7 09:06:54 2012 -0700
