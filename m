Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754Ab2ILOv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:51:27 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39887 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758854Ab2ILOvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:51:24 -0400
MIME-Version: 1.0
In-Reply-To: <1347461351.15764.47.camel@twins>
References: <1347459195-5491-1-git-send-email-eranian@google.com>
	<1347459195-5491-2-git-send-email-eranian@google.com>
	<1347459984.15764.34.camel@twins>
	<CABPqkBSnhjgAhn5+gOuBWWPrxKojKW1hKPJEn7zvvYhiw-LPLg@mail.gmail.com>
	<1347460719.15764.42.camel@twins>
	<CABPqkBSCY1N8Zc9ZxRYmQykqg+hiukxW4ZRMWkp9wfaOSzgGrA@mail.gmail.com>
	<1347461351.15764.47.camel@twins>
Date: Wed, 12 Sep 2012 16:51:23 +0200
Message-ID: <CABPqkBRiDjaCw9CEpWgjxeOu4ybgv=-ieRZwZLberiU9m9vHOg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] hrtimer: add hrtimer_init_cpu()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        Robert Richter <robert.richter@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 4:49 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-09-12 at 16:46 +0200, Stephane Eranian wrote:
>
>> I am fine with dropping this patch. I just found it odd there was a per-cpu
>> data reference embedded deep into the call. I wanted things to be more
>> explicit. I know it works without the proposed change.
>
> Ah the reason its there is to make sure the base pointer is a valid base
> pointer, this avoids an extra conditional in a number of places. Note
> that it uses raw_get_cpu_var(), so it doesn't even actually know which
> specific pointer goes in.
>
>
Ok, fine. Then let's drop this patch then.
Thanks for the explanations.
