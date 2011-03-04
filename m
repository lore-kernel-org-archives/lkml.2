Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624Ab1CDOJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:09:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58063 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463Ab1CDOJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:09:02 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=-NBgKsjfVa4A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=UpaswEPueBhchG7YPJYA:9 a=OiH8e4BKfxZYiHKcmMhy4a53QfUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] lockstat: export data in python expression
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <1298916475.5226.850.camel@laptop>
References: <4D67E286.8010907@dcl.info.waseda.ac.jp>
	 <1298905223-1807-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1298916475.5226.850.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 04 Mar 2011 09:08:58 -0500
Message-ID: <1299247738.6376.51.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-28 at 19:07 +0100, Peter Zijlstra wrote:
> On Tue, 2011-03-01 at 00:00 +0900, Hitoshi Mitake wrote:
> > I'm writing the tool for parsing and arranging the data of /proc/lock_stat
> > in python. But I soon found that lock_stat is hard to parse, so I wrote
> > this patch to let lock_stat output its information in python expression.
> 
> _IF_ we're going to do something like this, I'd much prefer a sane
> output format over something that's easily parseble by just one thing.

Right, I do not think the kernel should be exporting information in a
python (or any other) language.

If it is very difficult to parse, then I doubt anything is currently
parsing it, so it should be fine to change the format. Lets just change
it to something that is much easier to to parse and stick with that.

-- Steve


