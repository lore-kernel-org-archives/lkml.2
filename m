Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab0I3N4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 09:56:38 -0400
Received: from mtagate6.de.ibm.com ([195.212.17.166]:57342 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129Ab0I3N4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 09:56:36 -0400
Subject: Re: [RFC][PATCH 00/10] taskstats: Enhancements for precise
 accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <871v8bwrr1.fsf@basil.nowhere.org>
References: <1285249681.1837.28.camel@holzheu-laptop>
	 <871v8bwrr1.fsf@basil.nowhere.org>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Thu, 30 Sep 2010 15:56:26 +0200
Message-ID: <1285854986.1856.22.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andi,

On Thu, 2010-09-30 at 10:38 +0200, Andi Kleen wrote:
> Michael Holzheu <holzheu@linux.vnet.ibm.com> writes:
> >
> > Compared to the old top command that has to scan more than 1000 proc
> > directories the new ptop consumes much less CPU time (0.05% system time
> > on my s390 system).
> 
> Sounds like a nice advantage (and in a way goes back to old kmem ps) 
> 
> Are there plans to make the standard top command use this new interface
> or will it be only something for specialized utilities?

Currently there are no plans. We first have to discuss, if this should
be done at all. But if the new interface is there, of course the
standard top command could also use it. Especially, if we have an easy
to use user space library.

One problem when converting the standard top command to use the new
interface will be that currently not all information that is in proc is
in taskstats (and also the other way round).

Michael

