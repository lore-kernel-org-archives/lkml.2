Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab2CMQvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:51:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527Ab2CMQvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:51:47 -0400
Date: Tue, 13 Mar 2012 17:44:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120313164426.GA29112@redhat.com>
References: <20120309220244.GD19584@count0.beaverton.ibm.com> <20120309223932.GB725@moon> <20120309235901.GE19584@count0.beaverton.ibm.com> <20120310074854.GA3065@moon> <20120313024511.GF19584@count0.beaverton.ibm.com> <20120313062625.GA1912@moon> <20120313071812.GA6969@moon> <20120313154337.GA25711@redhat.com> <20120313160044.GF1912@moon> <20120313160420.GA18307@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313160420.GA18307@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13, Cyrill Gorcunov wrote:
>
> On Tue, Mar 13, 2012 at 08:00:44PM +0400, Cyrill Gorcunov wrote:
> > >
> > > This means that the num_exe_file_vmas check at the start is not needed.
> > > If you want it as a "fast-path" check, please fix the comment. Or just
> > > remove it. Otherwise the code looks as if we have to check them both.
> >
> > Yes, I wanted a fast test first, while the second test will give
> > one-shot condition and the second attempt to setup new exe_file
> > will fail. OK, I'll update the comment block.
> >
>
> Something like below?

Yes, looks good to me.

Oleg.

