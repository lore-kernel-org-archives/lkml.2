Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab0KDBm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 21:42:26 -0400
Received: from [120.204.251.227] ([120.204.251.227]:58111 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754411Ab0KDBmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 21:42:23 -0400
Subject: Re:[PATCH v2]oom-kill: CAP_SYS_RESOURCE should get bonus
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
To: figo zhang <figo1802@gmail.com>, David Rientjes <rientjes@google.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>
In-Reply-To: <AANLkTimjfmLzr_9+Sf4gk0xGkFjffQ1VcCnwmCXA88R8@mail.gmail.com>
References: <1288662213.10103.2.camel@localhost.localdomain>
	 <1288827804.2725.0.camel@localhost.localdomain>
	 <alpine.DEB.2.00.1011031646110.7830@chino.kir.corp.google.com>
	 <AANLkTimjfmLzr_9+Sf4gk0xGkFjffQ1VcCnwmCXA88R8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 09:38:57 +0800
Message-ID: <1288834737.2124.11.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2010 01:42:19.0434 (UTC) FILETIME=[84A288A0:01CB7BC1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> 
> 
> On Thu, 4 Nov 2010, Figo.zhang wrote:
> 
> > CAP_SYS_RESOURCE also had better get 3% bonus for protection.
> >
> 
> 
> Would you like to elaborate as to why?
> 
> 

process with CAP_SYS_RESOURCE capibility which have system resource
limits, like journaling resource on ext3/4 filesystem, RTC clock. so it
also the same treatment as process with CAP_SYS_ADMIN.

Best,

Figo.zhang



