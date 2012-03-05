Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965073Ab2CEUgC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:36:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964782Ab2CEUgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:36:00 -0500
Date: Mon, 5 Mar 2012 17:35:18 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, dsahern@gmail.com, ravitillo@lbl.gov,
        khandual@linux.vnet.ibm.com, asharma@fb.com, robert.richter@amd.com,
        ming.m.lin@intel.com, vweaver1@eecs.utk.edu, andi@firstfloor.org
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
Message-ID: <20120305203518.GA5656@infradead.org>
References: <20120224094048.GA7952@quad>
 <20120305154753.GA14604@elte.hu>
 <20120305155011.GA32413@elte.hu>
 <20120305155642.GB32413@elte.hu>
 <1330965033.11248.240.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330965033.11248.240.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 05, 2012 at 05:30:33PM +0100, Peter Zijlstra escreveu:
> On Mon, 2012-03-05 at 16:56 +0100, Ingo Molnar wrote:
> > A third usability bug is that for some reason a branch sampling 
> > 'perf report' defaults to the stdio output on my testsystem - 
> > with --no-branch-stack it gives the regular tui.

> Ah, I would not have noticed that since I still explicitly build my perf
> without TUI support. That stuff mostly just gets in the way.

Do you have any specific complaints about it?

There were changes to make it work as the stdio one when navigation keys
aren't used, i.e. color scheme, etc.

Its not there to be in the way, but to be useful, so any specific
complaints I would love to hear from you.

- Arnaldo
