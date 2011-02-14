Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab1BNPKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:10:43 -0500
Received: from www.tglx.de ([62.245.132.106]:47831 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab1BNPKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:10:42 -0500
Date: Mon, 14 Feb 2011 16:09:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v6 1/3] cgroups: export cgroup_iter_{start,next,end}
In-Reply-To: <20110214143902.GA3666@shutemov.name>
Message-ID: <alpine.LFD.2.00.1102141608250.26192@localhost6.localdomain6>
References: <1297688787-3592-1-git-send-email-kirill@shutemov.name> <1297688787-3592-2-git-send-email-kirill@shutemov.name> <alpine.LFD.2.00.1102141421500.26192@localhost6.localdomain6> <20110214143902.GA3666@shutemov.name>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011, Kirill A. Shutemov wrote:

> On Mon, Feb 14, 2011 at 02:27:44PM +0100, Thomas Gleixner wrote:
> > 
> > Lacks any sensible explanation why and whatfor this needs to be
> > exported.
> 
> I thought it's obvious since it's part of the patchset.
> Am I wrong?

Yes, because we want a sensible changelog for the patch itself.
 
> > And I really doubt that we want to export that at all.
> 
> Why?
> Do you think cgroup_timer_slack built as module is useless?

Pretty much.
 
Thanks,

	tglx
