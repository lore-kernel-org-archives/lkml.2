Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab0HKOLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 10:11:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39914 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab0HKOLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 10:11:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XJTCefxnCKz4AH+wWNnoYEPNhg76bY5K52P3u9hp/0oB6tlHCUU7cSmKkvAS8ohNzs
         qel/I+h0k30C519+iyUkvPcUdLl0Ct1njN19LmyS5vtkGKe4dRXaOQOZd7UmKnH2yiUa
         30YtB2WggVgV4aFHwviPFnWGVCS6uJmuEIxi8=
Date: Wed, 11 Aug 2010 16:11:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, tracing: add missing __percpu markups
Message-ID: <20100811141146.GA5381@nowhere>
References: <1281498479-28551-1-git-send-email-namhyung@gmail.com> <4C6256B4.1030304@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6256B4.1030304@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 09:52:20AM +0200, Tejun Heo wrote:
> On 08/11/2010 05:47 AM, Namhyung Kim wrote:
> > ftrace_event_call->perf_events, perf_trace_buf, fgraph_data->cpu_data and
> > some local variables are percpu pointers but were missing __percpu markup.
> > Add it.
> > 
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> 
> Acked-by: Tejun Heo <tj@kernel.org>


Queued, thanks!

