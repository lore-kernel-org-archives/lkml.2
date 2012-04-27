Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760571Ab2D0QVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:21:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:45351 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760431Ab2D0QVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:21:12 -0400
Message-ID: <1335543660.13683.113.camel@twins>
Subject: Re: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 27 Apr 2012 18:21:00 +0200
In-Reply-To: <20120427160922.GI18810@erda.amd.com>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
	 <1333390758-10893-7-git-send-email-robert.richter@amd.com>
	 <1334398906.2528.49.camel@twins> <20120423095659.GS9747@erda.amd.com>
	 <20120427123434.GF18810@erda.amd.com>
	 <CABPqkBS9FNmHBukzJqGJP1r5iqyLL9gz2g=3jvnt22pDxOdndA@mail.gmail.com>
	 <20120427125410.GG18810@erda.amd.com> <1335540633.2463.133.camel@laptop>
	 <20120427160922.GI18810@erda.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-27 at 18:09 +0200, Robert Richter wrote:
> 
> But do you agree to have level 1 and 2 mapped to ibs, not just only
> level 2 (since I don't want to fail with r076:p)? 

Sure, you can have 1 and 2 mean the same. 2 wants 0 skid, 1 wants
constant skid, 0 is a constant, therefore its consistent.
