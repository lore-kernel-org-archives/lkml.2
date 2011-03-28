Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1C1Iw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:52:28 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56463 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014Ab1C1Iw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 04:52:26 -0400
Date: Mon, 28 Mar 2011 09:52:23 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Lin Ming <ming.m.lin@intel.com>, mingo@elte.hu,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [RFC] perf: EBNF for event syntax
Message-ID: <20110328095223.76e4debe@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1301299090.4859.6.camel@twins>
References: <1300851416.31224.58.camel@minggr.sh.intel.com>
	<1301051277.2250.195.camel@laptop>
	<4D901F58.4060902@hitachi.com>
	<1301299090.4859.6.camel@twins>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 09:58:10 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Groups are most useful in measuring events on another base, which is
> basically mandatory if your primary event doesn't have sampling
> support itself.

Just FYI...

When I was looking at group event support for SH (because the hardware
doesn't have sampling support) I was trying to avoid the user being
required to setup the groups on the command-line, e.g. I wrote it so
that the group event creation was all done "behind the scenes".

For those architectures/platforms that are missing sampling support I
still think that group event creation should be as invisible as
possible.
