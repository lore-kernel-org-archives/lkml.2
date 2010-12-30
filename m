Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0L3SyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 13:54:03 -0500
Received: from smtp-out.google.com ([74.125.121.67]:42837 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab0L3SyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 13:54:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Ii3afQzF3yhDplRW3/wmq47KThMIS+SWeRNPLMGMerjXoLbpSjJYdVGrYxhjD51edk
         TRA3mdFgjDFPTA8sGUfg==
Date: Thu, 30 Dec 2010 10:53:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [build failure] Re: [PATCH -v2 3/6] x86, 64bit, numa: Put pgtable
 to local node memory
In-Reply-To: <20101230120153.GA16476@elte.hu>
Message-ID: <alpine.DEB.2.00.1012301052050.12995@chino.kir.corp.google.com>
References: <4D1BC856.4010202@kernel.org> <4D1BC94C.5040100@zytor.com> <AANLkTikknHfA4TQw+SMH-EyJBHoNHXk8Rheq4=K4jNWA@mail.gmail.com> <alpine.DEB.2.00.1012291637270.6040@chino.kir.corp.google.com> <4D1BD928.50701@zytor.com> <alpine.DEB.2.00.1012291702180.7374@chino.kir.corp.google.com>
 <4D1BE615.4000700@zytor.com> <20101230090648.GB7306@elte.hu> <20101230102815.GA29822@elte.hu> <20101230103002.GA30020@elte.hu> <20101230120153.GA16476@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531368966-942838037-1293735235=:12995"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-942838037-1293735235=:12995
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 30 Dec 2010, Ingo Molnar wrote:

> 
> and x86/numa has this build failure:
> 
> arch/x86/mm/numa_64.c: In function ‘numa_set_cpumask’:
> arch/x86/mm/numa_64.c:851:14: error: ‘physnodes’ undeclared (first use in this function)
> arch/x86/mm/numa_64.c:851:14: note: each undeclared identifier is reported only once for each function it appears in
> 
> config attached.
> 

Yeah, you reported this one earlier and I sent a patch four days ago to 
fix it (http://marc.info/?l=linux-kernel&m=129340072128297).  I'll reply 
to this email with it again.

Thanks!
--531368966-942838037-1293735235=:12995--
