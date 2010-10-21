Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab0JUKIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:08:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53598 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab0JUKId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:08:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
Subject: Re: Ftrace: can trace kthread?
Cc: kosaki.motohiro@jp.fujitsu.com, Yong Zhang <yong.zhang0@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <1287654765.2237.18.camel@myhost>
References: <AANLkTinkMrsRQ8tdCrTj57SA_qHYrg+-qCqZpyQZ-FMr@mail.gmail.com> <1287654765.2237.18.camel@myhost>
Message-Id: <20101021190831.C8EB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 21 Oct 2010 19:08:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > >
> > > [root@myhost tracing]# ps -ax | grep flush
> > > Warning: bad ps syntax, perhaps a bogus '-'? See http://procps.sf.net/faq.html
> > >  1205 ?        S      0:01 [flush-8:0]
> > > 11852 pts/1    S+     0:00 grep flush
> > > [root@myhost tracing]#
> > >
> > > so my flusher pid is 1205, i do it as below:
> > >
> > > [root@myhost tracing]# echo 0 > tracing_enabled
> > > [root@myhost tracing]# echo function > current_tracer
> > > [root@myhost tracing]# echo 1205 > set_ftrace_pid
> > > [root@myhost tracing]# echo 1 > tracing_enabled
> > >
> > > wait ... and open some pdf files, let system eat huge memory...
> > >
> > > [root@myhost tracing]# echo 0 > tracing_enabled
> > > [root@myhost tracing]# cat trace
> > > # tracer: function
> > > #
> > > #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> > > #              | |       |          |         |
> > >
> > >
> > > but i canot trace nothing.
> > 
> > Is tracing_on enable(1) on your system?
> > I enable it on my system by default, so I didn't show it in the previous mail.
> > 
> 
> tracing_on is sure on, my kernel is 2.6.36-rc8, what is your kernel
> version?

2.6.36-rc8 + Yong's way works perfectly fine on my x86_64 desktop.

thanks.



