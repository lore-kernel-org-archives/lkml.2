Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab2GCNlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 09:41:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41051 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab2GCNlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 09:41:44 -0400
Date: Tue, 3 Jul 2012 15:41:34 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] Potential fix for leapsecond caused futex
 related load spikes
Message-ID: <20120703134134.GA19558@localhost.localdomain>
References: <4FF06CAB.9020800@redhat.com>
 <4FF08154.3050407@redhat.com>
 <4FF088B9.1000308@us.ibm.com>
 <20120702101606.GA16008@localhost.localdomain>
 <20120702200821.GA31197@swielinga.nl>
 <20120703092325.GA18121@localhost.localdomain>
 <20120703120535.GA30998@swielinga.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120703120535.GA30998@swielinga.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 02:05:36PM +0200, Sytse Wielinga wrote:
> On Tue, Jul 03, 2012 at 11:23:25AM +0200, Richard Cochran wrote:
> > I think the established practice of announcing the event by network is
> > the only sane way of handling this issue. The list of TAI-UTC offsets
> > belongs to what David Mills has called our "institutional memory", and
> > this is a user space issue. The kernel's job is to just live in the
> > moment and provide the right time for *now*.
> 
> I do suppose hardware clock and file system times will have to be UTC (or
> UTC-based local time) though?

Yes, you are right. Those things can never change. What I have in mind
is purely internal to the kernel and won't be visible in any way.

Thanks,
Richard

 
