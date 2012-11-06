Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2KFXPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 18:15:31 -0500
Received: from mail-ye0-f174.google.com ([209.85.213.174]:61228 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab2KFXP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 18:15:27 -0500
Date: Tue, 6 Nov 2012 20:15:19 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-man@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Stephane Eranian <eranian@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFCv2] perf: proposed perf_event_open() manpage
Message-ID: <20121106231519.GH3430@ghostprotocols.net>
References: <alpine.DEB.2.02.1211061748120.30004@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1211061748120.30004@vincent-weaver-1.um.maine.edu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 06, 2012 at 05:53:27PM -0500, Vince Weaver escreveu:
> .TP
> .IR "mmap"
> The
> .I mmap
> bit enables recording of extra information to a
> mmap'd ring-buffer.
> This is
> described below in subsection MMAP Layout.

Enables the recording of exec mmap events, its counterpart, for data
maps is...

> .IR "mmap_data" " (Since Linux 2.6.36)"
> Include mmap events in the ring_buffer.

That will include mmap events for data maps.
 
> .TP
> .IR "sample_id_all" " (Since Linux 2.6.38)"
> If set, then all sample ID info (TID, TIME, ID, CPU, STREAM_ID)
> will be provided.

No, it will obey sample_type for non SAMPLE PERF_RECORD_ events,
so if you want timestamps in all events so that you can detect
reordering, use it a sample_type with PERF_SAMPLE_TIME and
sample_id_all.
 
I'll read it again tomorrow, thanks for writing it!

- Arnaldo
