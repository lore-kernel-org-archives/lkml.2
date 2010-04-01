Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab0DARDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:03:42 -0400
Received: from mail.perches.com ([173.55.12.10]:1315 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab0DARDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:03:36 -0400
Subject: Re: [PATCH 1/2 v4] scsi: add __print_hex() to ftrace
From: Joe Perches <joe@perches.com>
To: rostedt@goodmis.org
Cc: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Ingo Molnar <mingo@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
In-Reply-To: <1270130265.19685.8933.camel@gandalf.stny.rr.com>
References: <4BB4855E.7030509@jp.fujitsu.com>
	 <4BB4864A.3060406@jp.fujitsu.com>
	 <1270130265.19685.8933.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 10:03:32 -0700
Message-ID: <1270141412.1483.130.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 09:57 -0400, Steven Rostedt wrote:
> > +const char *
> > +ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
> > +{
> > +	int i;
> > +	const char *ret = p->buffer + p->len;
> > +
> > +	for (i = 0; i < buf_len; i++)
> > +		trace_seq_printf(p, "%s%2.2x", i == 0 ? "" : " ", buf[i]);
> > +
> > +	trace_seq_putc(p, 0);

hex_dump_to_buffer?


