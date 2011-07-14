Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1GNC6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 22:58:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33697 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1GNC6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 22:58:00 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=puk10441YtwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=cm27Pg_UAAAA:8 a=uAS_uZ3KAAAA:8 a=Jr5Azk1qO15ycm2-cp4A:9 a=QEXdDO2ut3YA:10 a=zv9_9hqRWm8A:10 a=OEjQ10uNE_sA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] [RFCv2] perf: robustify proc and debugfs file recording
From: Steven Rostedt <rostedt@goodmis.org>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: mikey@neuling.org, acme@redhat.com, anton@samba.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1310604019-10935-1-git-send-email-sonnyrao@chromium.org>
References: <28585.1310602685@neuling.org>
	 <1310604019-10935-1-git-send-email-sonnyrao@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 22:57:57 -0400
Message-ID: <1310612277.27864.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-13 at 17:40 -0700, Sonny Rao wrote:
> While attempting to create a timechart of boot up I found
> perf didn't tolerate modules being loaded/unloaded.  This patch
> fixes this by reading the file once and then writing the size
> read at the correct point in the file.  It also simplifies the
> code somewhat.
> 

I get this:

cc1: warnings being treated as errors
util/trace-event-info.c: In function ‘read_header_files’:
util/trace-event-info.c:221: error: unused variable ‘size’
util/trace-event-info.c: In function ‘copy_event_system’:
util/trace-event-info.c:255: error: unused variable ‘size’
make: *** [/tmp/build/util/trace-event-info.o] Error 1

-- Steve


> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> Signed-off-by: Michael Neuling <mikey@neuling.org>


