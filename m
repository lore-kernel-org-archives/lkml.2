Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab0IOPKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:10:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25766 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab0IOPKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:10:51 -0400
Date: Wed, 15 Sep 2010 08:10:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>,
        lkml <linux-kernel@vger.kernel.org>, Naohiro Aota <naota@elisp.net>
Subject: Re: [PATCH] docbook: add idr/ida to kernel-api docbook
Message-Id: <20100915081013.2daa1ad6.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LNX.2.00.1009151657080.26813@pobox.suse.cz>
References: <20100914150851.f5ae1da2.randy.dunlap@oracle.com>
	<4C908047.404@kernel.org>
	<alpine.LNX.2.00.1009151657080.26813@pobox.suse.cz>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 16:57:36 +0200 (CEST) Jiri Kosina wrote:

> On Wed, 15 Sep 2010, Tejun Heo wrote:
> 
> > On 09/15/2010 12:08 AM, Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Add idr/ida to kernel-api docbook.
> > > Fix typos and kernel-doc notation.
> > > 
> > > Includes idr patches from Naohiro Aota <naota@elisp.net> (for
> > > completeness only; will wait for those to be merged via the trivial tree).
> > > 
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > > Cc: Tejun Heo <tj@kernel.org>
> > > Cc: Naohiro Aota <naota@elisp.net>
> > > Cc: Jiri Kosina <jkosina@suse.cz>
> > 
> > Acked-by: Tejun Heo <tj@kernel.org>
> > 
> > Thank you.
> 
> What is this based on? As it doesn't apply on top of current Linus' tree, 
> I will probably not be taking it throgh trivial queue, ok?

It is based on 2.6.36-rc4, with Naohiro's patches applied by hand.

I'll merge it later (after your next trivial merge, I guess).  Thanks.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
