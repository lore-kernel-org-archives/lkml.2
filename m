Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab2I1LjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 07:39:15 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60268 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab2I1LjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 07:39:14 -0400
MIME-Version: 1.0
In-Reply-To: <1348824980.3292.68.camel@twins>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	<1348806696-31170-27-git-send-email-andi@firstfloor.org>
	<1348824980.3292.68.camel@twins>
Date: Fri, 28 Sep 2012 13:39:10 +0200
Message-ID: <CABPqkBQxjag+fjRa7D2xyc0iKKRHg64gYCTqJ=UPXFW_wkGNkg@mail.gmail.com>
Subject: Re: [PATCH 26/31] perf, x86: Support for printing PMU state on
 spurious PMIs
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 11:36 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:
>
>> +static bool print_spurious_pmi __read_mostly;
>> +module_param(print_spurious_pmi, bool, 0644);
>
> Shouldn't this be a per-pmu sysfs attr?

agreed.
