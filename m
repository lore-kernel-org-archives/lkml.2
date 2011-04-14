Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab1DNNwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 09:52:47 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:36682 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab1DNNwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 09:52:46 -0400
From: Richard Weinberger <richard@nod.at>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: gcc-4.6.0 generates no code for sub_preempt_count()
Date: Thu, 14 Apr 2011 15:52:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
References: <201104132150.05623.richard@nod.at> <19878.42746.60978.537126@pilspetsen.it.uu.se>
In-Reply-To: <19878.42746.60978.537126@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104141552.42213.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 14 April 2011, 09:49:14 schrieb Mikael Pettersson:
> Richard Weinberger writes:
>  > Hi,
>  > 
>  > I'm facing a very strange issue with gcc-4.6.0 and UML.
>  > Within __local_bh_enable() gcc generates no code for
>  > sub_preempt_count().
>  > 
>  > See:
>  > http://userweb.kernel.org/~rw/uml-gcc460/__local_bh_enable-gcc460.txt
>  > vs.
>  > http://userweb.kernel.org/~rw/uml-gcc460/__local_bh_enable-gcc431.txt
>  > 
>  > Interestingly it generates code for add_preempt_count().
>  > I can reproduce this on x86 and x86_64.
>  > 
>  > The problem has to do with UML's current_thread_info() function.
>  > When I replace it with arch/x86's (unportable) variant gcc generates
>  > code.
>  > 
>  > Any ideas whether this is a gcc or a kernel issue?
> 
> Please provide a standalone test case.

There you go!
http://userweb.kernel.org/~rw/uml-gcc460/testcase.c

Thanks,
//richard
