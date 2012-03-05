Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab2CEQa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:30:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53348 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab2CEQa6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:30:58 -0500
Message-ID: <1330965033.11248.240.camel@twins>
Subject: Re: [PATCH] perf report: auto-detect branch stack sampling mode
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, ravitillo@lbl.gov,
        khandual@linux.vnet.ibm.com, asharma@fb.com, robert.richter@amd.com,
        ming.m.lin@intel.com, vweaver1@eecs.utk.edu, andi@firstfloor.org
Date: Mon, 05 Mar 2012 17:30:33 +0100
In-Reply-To: <20120305155642.GB32413@elte.hu>
References: <20120224094048.GA7952@quad> <20120305154753.GA14604@elte.hu>
	 <20120305155011.GA32413@elte.hu> <20120305155642.GB32413@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-05 at 16:56 +0100, Ingo Molnar wrote:
> A third usability bug is that for some reason a branch sampling 
> 'perf report' defaults to the stdio output on my testsystem - 
> with --no-branch-stack it gives the regular tui.
> 
> 
Ah, I would not have noticed that since I still explicitly build my perf
without TUI support. That stuff mostly just gets in the way.
