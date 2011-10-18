Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab1JROnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:43:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:44708 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab1JROnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:43:46 -0400
Subject: Re: Oprofile Regression Caused by commit
 e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25 on PPC
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric B Munson <emunson@mgebm.net>
Cc: Stephane Eranian <eranian@google.com>, mingo@elte.hu, anton@samba.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, hbabu@us.ibm.com
Date: Tue, 18 Oct 2011 16:43:22 +0200
In-Reply-To: <20111018135322.GA11530@mgebm.net>
References: <20111007204247.GA5444@mgebm.net>
	 <20111010233842.GC24583@mgebm.net> <1318319095.14400.54.camel@laptop>
	 <20111012165154.GB6158@mgebm.net>
	 <CABPqkBRHkiOYEW+5Yo9p43c_2Dy+aAdJRXj3tah5J1QsV4AXrw@mail.gmail.com>
	 <20111018135322.GA11530@mgebm.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318949002.21167.20.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 09:53 -0400, Eric B Munson wrote:
> On Wed, 12 Oct 2011, Stephane Eranian wrote:
> 
> > Could be:
> >    a8d757e perf events: Fix slow and broken cgroup context switch code
> > 
> 
> Thanks for the pointer, but the fix was in:
>     facc4307 perf: Optimize event scheduling locking
> 
> This might be a candidate for stable given that oprofile is broken without it.

I might feel much more confident about recommending that if someone
could explain why that patches fixes what exact problem.
