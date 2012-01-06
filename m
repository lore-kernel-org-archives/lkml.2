Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451Ab2AFBrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 20:47:53 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46721 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758438Ab2AFBrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 20:47:52 -0500
Date: Fri, 6 Jan 2012 02:47:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Jan Beulich <JBeulich@suse.com>,
        mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: x86-64: memset()/memcpy() not fully standards compliant
Message-ID: <20120106014748.GS11715@one.firstfloor.org>
References: <4F05BBFE020000780006A983@nat28.tlf.novell.com> <20120105182846.GQ11715@one.firstfloor.org> <4F0630CC.7050001@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F0630CC.7050001@zytor.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 03:22:52PM -0800, H. Peter Anvin wrote:
> On 01/05/2012 10:28 AM, Andi Kleen wrote:
> >>
> >> Otherwise, is there any rationale for this sort of lurking bug?
> > 
> > Most (all?) of the CPUs I cared about when writing that code had 
> > bugs with string instructions and >4GB.
> > 
> 
> Is that still true, and do we even use string instructions still on
> those old CPUs?  Jan's fixes don't introduce any additional delays in
> the non-string-instruction paths.

Yes various of the CPUs with bugs used string instructions.

Don't know the state on current CPUs.

Both string and non string instructions are used on modern CPUs,
so making any of that slower is not a good idea.

-Andi
