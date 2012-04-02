Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2DBTLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:11:41 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55588 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab2DBTLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:11:36 -0400
Date: Mon, 2 Apr 2012 21:11:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
Message-ID: <20120402191123.GA17124@gmail.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

>  perf record -a -e cpu-cycles:p ...    # use ibs op counting cycle count

Cool - this makes IBS really useful!

Mind posting some perf annotate output of any well-known kernel 
function showing skiddy '-e cpu-cycles' output versus skid-less 
'-e cpu-cycles:p' output?

I'm curious how well this works in practice.

Thanks,

	Ingo
