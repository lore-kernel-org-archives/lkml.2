Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655Ab2DYL0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:26:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585Ab2DYL0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:26:18 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=EC6Uyf8RYSQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=FDAbc1_C4EvKoK8eQwUA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335353176.28106.161.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/4] ftrace: Remove unused ftrace_update_time
 variable/code
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 25 Apr 2012 07:26:16 -0400
In-Reply-To: <1335342219-2782-3-git-send-email-jolsa@redhat.com>
References: <1335342219-2782-1-git-send-email-jolsa@redhat.com>
	 <1335342219-2782-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 10:23 +0200, Jiri Olsa wrote:
> The update time of the records update is meassured but never
> used. It was probably dropped along the way, removing it.

No it's not dropped. I have patches that read it. But you are correct,
that I should either add those patches, or moved this code out into
those patches, and keep the kernel clean.

Actually, as there's a debug file in the debugfs code now
(dyn_ftrace_total_info). That would be a good place to put this info.

-- Steve

> 
> Also changing ftrace_update_cnt static variable into automatic,
> since it's used only in ftrace_update_code function.



