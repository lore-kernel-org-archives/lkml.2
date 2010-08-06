Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982Ab0HFQE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 12:04:58 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37501 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab0HFQE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 12:04:56 -0400
Date: Fri, 6 Aug 2010 18:04:41 +0200
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: "fweisbec@gmail.com" <fweisbec@gmail.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 7/9] perf: Export cpumap
Message-ID: <20100806160441.GA3987@kryptos.osrc.amd.com>
References: <1281104713-23141-1-git-send-email-bp@amd64.org>
 <1281104713-23141-8-git-send-email-bp@amd64.org>
 <20100806143912.GB13780@ghostprotocols.net>
 <20100806144939.GD21628@aftab>
 <20100806151413.GD13780@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806151413.GD13780@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Fri, Aug 06, 2010 at 12:14:13PM -0300

> > I'm afraid not since earlier patches in the series introduce the
> > toplevel Makefile that glues all the different tools/lib/* parts
> > together. However, I could extract the toplevel Makefile parts and
> > cpumap.c and ctype.c if you really need it now - I've been doing this so
> > often lately that I could do it with my eyes closed now :o).
> 
> :-)
> 
> We need to get back at merging that series, so some patch series
> installments, with say, 3 or 4 patches each, would be great.

Yeah, I just want to wait first until all the churn on the kernel side
settles and we have agreed on the perf_event.c part which would also
determine what needs exporting on the userspace side.

But if you need stuff exported from perf/util/ for other tools too and
if you tell me which ones, I could cook up something real soon...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
