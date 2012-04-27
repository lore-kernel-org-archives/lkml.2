Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728Ab2D0PtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:49:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:44802 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760709Ab2D0PtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:49:01 -0400
Subject: Re: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS
 for AMD CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120427125410.GG18810@erda.amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
	 <1333390758-10893-7-git-send-email-robert.richter@amd.com>
	 <1334398906.2528.49.camel@twins> <20120423095659.GS9747@erda.amd.com>
	 <20120427123434.GF18810@erda.amd.com>
	 <CABPqkBS9FNmHBukzJqGJP1r5iqyLL9gz2g=3jvnt22pDxOdndA@mail.gmail.com>
	 <20120427125410.GG18810@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Apr 2012 17:30:33 +0200
Message-ID: <1335540633.2463.133.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 14:54 +0200, Robert Richter wrote:
> My suggestions was to use level 1 for all samples and level 2 for
> samples that only contain a precise rip, saving level 3 for future
> use. 

No.

