Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0ENQM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:12:58 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57028 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab0ENQM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:12:56 -0400
Date: Fri, 14 May 2010 18:12:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf/trace: use read() instead of lseek() in
 trace_event_read.c:skip()
Message-ID: <20100514161255.GA8535@kryptos.osrc.amd.com>
References: <1273032130.6383.28.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273032130.6383.28.camel@tropicana>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>
Date: Tue, May 04, 2010 at 11:02:10PM -0500

Hi,

> Here's a small fix for a problem affecting live-mode, introduced in the
> past day or so:
> 
> root@tropicana:~# perf trace rwtop
> perf trace started with Perl
> script /root/libexec/perf-core/scripts/perl/rwtop.pl
> 
>   Fatal: did not read header event
> 
> commit d00a47cce569a3e660a8c9de5d57af28d6a9f0f7 added a skip()
> function to skip over e.g. header_page, but this doesn't work for live
> mode.  This patch re-implements skip() to use read() instead of
> lseek() to fix that.
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>

has this one landed in any tree in the meantime?

tip/perf/core doesn't have it.

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.
