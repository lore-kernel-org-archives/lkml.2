Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab1DNHtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 03:49:18 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:63887 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab1DNHtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:49:17 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19878.42746.60978.537126@pilspetsen.it.uu.se>
Date: Thu, 14 Apr 2011 09:49:14 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: gcc-4.6.0 generates no code for sub_preempt_count()
In-Reply-To: <201104132150.05623.richard@nod.at>
References: <201104132150.05623.richard@nod.at>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger writes:
 > Hi,
 > 
 > I'm facing a very strange issue with gcc-4.6.0 and UML.
 > Within __local_bh_enable() gcc generates no code for sub_preempt_count().
 > 
 > See:
 > http://userweb.kernel.org/~rw/uml-gcc460/__local_bh_enable-gcc460.txt
 > vs.
 > http://userweb.kernel.org/~rw/uml-gcc460/__local_bh_enable-gcc431.txt
 > 
 > Interestingly it generates code for add_preempt_count().
 > I can reproduce this on x86 and x86_64.
 > 
 > The problem has to do with UML's current_thread_info() function.
 > When I replace it with arch/x86's (unportable) variant gcc generates code.
 > 
 > Any ideas whether this is a gcc or a kernel issue?

Please provide a standalone test case.
