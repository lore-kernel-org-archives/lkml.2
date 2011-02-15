Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1BOGFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 01:05:33 -0500
Received: from www.tglx.de ([62.245.132.106]:60835 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab1BOGFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 01:05:31 -0500
Date: Tue, 15 Feb 2011 07:04:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matt Helsley <matthltc@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH, v6 3/3] cgroups: introduce timer slack controller
In-Reply-To: <20110214223939.GA6230@shutemov.name>
Message-ID: <alpine.LFD.2.00.1102150658540.26192@localhost6.localdomain6>
References: <1297688787-3592-1-git-send-email-kirill@shutemov.name> <1297688787-3592-4-git-send-email-kirill@shutemov.name> <alpine.LFD.2.00.1102141432440.26192@localhost6.localdomain6> <20110214151914.GA4210@shutemov.name> <alpine.LFD.2.00.1102141753240.26192@localhost6.localdomain6>
 <20110214223939.GA6230@shutemov.name>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Feb 2011, Kirill A. Shutemov wrote:
> On Mon, Feb 14, 2011 at 06:01:06PM +0100, Thomas Gleixner wrote:
> > > I think silent change here is wrong. cpuset returns -EBUSY in similar
> > > case.
> > 
> > And how is cpuset relevant for this ? Not at all. This is about
> > timer_slack and we better have a well defined scheme for all of this
> > and not some cobbled together thing with tons of exceptions and corner
> > cases. Of course undocumented as far the code goes.
> 
> I don't like silent cascade changes. Userspace can implement it if
> needed. -EBUSY is appropriate.

And I don't like totally uncommented code which follows come cobbled
together completely non obvious rules.

It's not about what you like. It's about getting useful functionality
when we add a new infrastructure like this.

So could you please explain what the rules of updating are, so that a
reviewer has a chance to understand the rationale of all this.

Thanks,

	tglx


