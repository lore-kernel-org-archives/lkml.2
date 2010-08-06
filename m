Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761488Ab0HFOtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:49:09 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41742 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948Ab0HFOtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:49:05 -0400
Date: Fri, 6 Aug 2010 16:49:39 +0200
From: Borislav Petkov <bp@amd64.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: "fweisbec@gmail.com" <fweisbec@gmail.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 7/9] perf: Export cpumap
Message-ID: <20100806144939.GD21628@aftab>
References: <1281104713-23141-1-git-send-email-bp@amd64.org>
 <1281104713-23141-8-git-send-email-bp@amd64.org>
 <20100806143912.GB13780@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806143912.GB13780@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Fri, Aug 06, 2010 at 10:39:12AM -0400

> Em Fri, Aug 06, 2010 at 04:25:11PM +0200, Borislav Petkov escreveu:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Export cpu counting and cpumap manipulating utils for general use. This
> > pulls ctype.c along.
> > 
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> 
> Is this independent of previous patches? I.e. to be applied to current
> perf/core?

I'm afraid not since earlier patches in the series introduce the
toplevel Makefile that glues all the different tools/lib/* parts
together. However, I could extract the toplevel Makefile parts and
cpumap.c and ctype.c if you really need it now - I've been doing this so
often lately that I could do it with my eyes closed now :o).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
