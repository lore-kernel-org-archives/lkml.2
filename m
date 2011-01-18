Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab1ARS0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 13:26:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45582 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1ARS0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 13:26:20 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=44vUGAvzfu8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=_zKhTNVO5qYHPEbAlJEA:9 a=xkbgsD4BLOUqchNWjNcA:7 a=-aYuJMV6LaqUp4LNjZrmRTeRmXUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: David Miller <davem@davemloft.net>, richm@oldelvet.org.uk,
        609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
In-Reply-To: <1295374595.12215.32.camel@gandalf.stny.rr.com>
References: <1295273486.16479.15.camel@gandalf.stny.rr.com>
	 <20110117.213448.226787087.davem@davemloft.net>
	 <20110117.220039.71097651.davem@davemloft.net>
	 <20110117.220857.104046847.davem@davemloft.net>
	 <20110118164633.GA12872@Krystal>
	 <1295372019.12215.30.camel@gandalf.stny.rr.com>
	 <1295374595.12215.32.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 18 Jan 2011 13:26:18 -0500
Message-ID: <1295375178.12215.33.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 13:16 -0500, Steven Rostedt wrote:
> On Tue, 2011-01-18 at 12:33 -0500, Steven Rostedt wrote:
> > On Tue, 2011-01-18 at 11:46 -0500, Mathieu Desnoyers wrote:
> 
> > > Also align TRACE_PRINTKS on 8 bytes to make sure the beginning of the section is
> > > aligned on pointer size.
> > 
> > If I can make it crash without the alignments and this fixes the issue,
> > I'll apply both patches.
> 
> After applying David's patch, I do indeed get a crash. I'll now apply
> yours and see if it fixes the issue.

Your patch doesn't seem to fix it either. I'll investigate this further.

-- Steve


