Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab1BCHDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 02:03:23 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:38029 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab1BCHDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 02:03:22 -0500
Date: Thu, 3 Feb 2011 09:03:20 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: John David Anglin <dave@hiauly1.hia.nrc.ca>
cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.38-rc3 regression on parisc: segfaults
In-Reply-To: <20110203022420.A73F54E7B@hiauly1.hia.nrc.ca>
Message-ID: <alpine.SOC.1.00.1102030902390.26784@math.ut.ee>
References: <20110203022420.A73F54E7B@hiauly1.hia.nrc.ca>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If aptitude fails consistently, it should be possible to debug or
> isolate to a particular kernel change.  Usually, SMP segvs don't
> provide much information as to the cause of the problem.  strace
> output and a gdb backtrace would be useful.

It's not failing consitently - it's in different places. I'm bisecting 
now.

-- 
Meelis Roos (mroos@linux.ee)
