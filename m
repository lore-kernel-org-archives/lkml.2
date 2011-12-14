Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab1LNRmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:42:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50757 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab1LNRmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:42:22 -0500
MIME-Version: 1.0
In-Reply-To: <1323770542.9082.9.camel@twins>
References: <1323559734-3488-1-git-send-email-eranian@google.com>
	<1323559734-3488-3-git-send-email-eranian@google.com>
	<1323694657.13285.12.camel@twins>
	<20111212173215.GI23870@elte.hu>
	<CABPqkBQJZNFC3cnXWz1ycnFDKqY6j9QeoMnq_zxH138e2Tt6kQ@mail.gmail.com>
	<1323770542.9082.9.camel@twins>
Date: Wed, 14 Dec 2011 09:42:21 -0800
Message-ID: <CABPqkBTimBNxCA3p=VkNCRAa-bwz=x4Q+=Nzse=HX89TNWnnWw@mail.gmail.com>
Subject: Re: [PATCH 2/4] perf_event: add PERF_COUNT_HW_REF_CPU_CYCLES generic
 PMU event
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        acme@infradead.org, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 2:02 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-12-12 at 22:45 -0800, Stephane Eranian wrote:
>
>> Isn't CPU_REF_CYCLES good enough?
>
> I was just asking.. someone needs to ;-)
>
> Took the remaining patches as well, thanks!

Ok, thanks.
