Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234Ab0E1VfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 17:35:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47416 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab0E1VfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 17:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hOx3B4igpSfUxuWgMbR5OsZCMyshfRUdBlID0Hpfe2I4Q4J7t61uVPrkcxR7UsaP/2
         DAd1OY4Cnbr+uln16yEDp9Ps5V9Ox9WrSEfIvp/C8V6lyz8cOOLltmi2kNzb8YRfU9zH
         BBo5iuQd7UDQIit1G4nqVn1U2t+C3Ggt9fz5k=
Date: Sat, 29 May 2010 01:35:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [Q] perf, x86: should perf_event_x.c being compiled conditionally?
Message-ID: <20100528213503.GJ20839@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while was building the kernel for pretty old laptop I've noticed
that perf_event_x.c depends on CONFIG_CPU_SUP_ only. So I'm somehow
confused. Should not some additional condition being used?

For example if a person have Core 2 or Nehalem machine, he will
definitely not need p6 and p4 events (yes, they are not _that_ big
in size, but anyway).

On the other hands distro builders would prefer to have all compiled in.

Not sure about what is the best way to resolve this, but perhaps I'm just
missing some key moment?

	-- Cyrill
