Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952Ab1DPKJL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 06:09:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48466 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab1DPKJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 06:09:04 -0400
Subject: Re: [PATCH 4/4] perf, x86: Fix event scheduler to solve complex
 scheduling problems
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20110416094348.GA24711@elte.hu>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
	 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
	 <1302943877.32491.9.camel@twins>  <20110416094348.GA24711@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 16 Apr 2011 12:08:40 +0200
Message-ID: <1302948520.32491.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-16 at 11:43 +0200, Ingo Molnar wrote:
> I'd also prefer if we first had actual testcases in 'perf test' for all these 
> failures - it took an *awfully* long time to find these regressions (the event 
> scheduler code has been committed for months), while with proper testcases it 
> would only take a second to run 'perf test'. 

These cases only exist on AMD F15, I don't think there's many people
with such systems around.
