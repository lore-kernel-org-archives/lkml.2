Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab1BNOjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:39:05 -0500
Received: from shutemov.name ([188.40.19.243]:48834 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab1BNOjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:39:03 -0500
Date: Mon, 14 Feb 2011 16:39:02 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v6 1/3] cgroups: export cgroup_iter_{start,next,end}
Message-ID: <20110214143902.GA3666@shutemov.name>
References: <1297688787-3592-1-git-send-email-kirill@shutemov.name>
 <1297688787-3592-2-git-send-email-kirill@shutemov.name>
 <alpine.LFD.2.00.1102141421500.26192@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102141421500.26192@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 02:27:44PM +0100, Thomas Gleixner wrote:
> 
> Lacks any sensible explanation why and whatfor this needs to be
> exported.

I thought it's obvious since it's part of the patchset.
Am I wrong?

> And I really doubt that we want to export that at all.

Why?
Do you think cgroup_timer_slack built as module is useless?

> > +EXPORT_SYMBOL_GPL(cgroup_iter_start);
> > +EXPORT_SYMBOL_GPL(cgroup_iter_next);
> > +EXPORT_SYMBOL_GPL(cgroup_iter_end);
> 
> Thanks,
> 
> 	tglx

-- 
 Kirill A. Shutemov
