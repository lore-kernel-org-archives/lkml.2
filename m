Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab2A3WGt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:06:49 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54909 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab2A3WGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:06:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of msb@google.com designates 10.68.199.4 as permitted sender) smtp.mail=msb@google.com; dkim=pass header.i=msb@google.com
Date: Mon, 30 Jan 2012 14:06:33 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Tejun Heo <tj@kernel.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH] cgroup: remove extra calls to find_existing_css_set
Message-ID: <20120130220633.GT4656@google.com>
References: <1327956716-11537-1-git-send-email-msb@chromium.org>
 <20120130210128.GA27051@google.com>
 <20120130210404.GA27616@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130210404.GA27616@google.com>
X-Operating-System: Linux/2.6.38.8-gg683 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo (tj@kernel.org) wrote:
> On Mon, Jan 30, 2012 at 01:01:28PM -0800, Tejun Heo wrote:
> > Hello,
> > 
> > On Mon, Jan 30, 2012 at 12:51:56PM -0800, Mandeep Singh Baines wrote:
> > > -	/*
> > > +        /*
> > 
> > Whitespace contamination fixed.
> > 
> > Applied to cgroup/for-3.4 w/ previous Acked-by's added.  Please
> > collect them on submission.
> 
> Ooh, never mind.  I was confused with acks to other patches.  Only Li
> has acked it, right?  If somebody else also acked it, please scream.
> 

Yep. Just Li.

> Thanks.
> 
> -- 
> tejun
