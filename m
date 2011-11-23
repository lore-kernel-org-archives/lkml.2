Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997Ab1KWBmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:42:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53854 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab1KWBmC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:42:02 -0500
Message-ID: <4ECC4FDC.1010506@cn.fujitsu.com>
Date: Wed, 23 Nov 2011 09:43:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: let trace_signal_generate() report more
 info,	kill overflow_fail/lose_info
References: <20111121191920.GA24883@redhat.com> <1321905799.20742.20.camel@frodo> <20111121202110.GA27966@redhat.com> <1321912356.20742.24.camel@frodo> <20111122205239.GA20971@redhat.com> <20111122205258.GB20971@redhat.com>
In-Reply-To: <20111122205258.GB20971@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-23 09:41:46,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-23 09:41:47,
	Serialize complete at 2011-11-23 09:41:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /**
>   * signal_generate - called when a signal is generated
>   * @sig: signal number
>   * @info: pointer to struct siginfo
>   * @task: pointer to struct task_struct
> + * @group: shared or private
> + * @resutl: TRACE_SIGNAL_*
>   *

s/resutl/result ;)
