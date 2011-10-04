Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab1JDMfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 08:35:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12584 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab1JDMfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 08:35:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=AnnBIoutNvdwNM2ZACwvFsAbGXTi4YyRa7uzuTKv8jE67fbGVwjrWAN0e4jOx8aLy
	aT7sGAL0DxsKHjiUn2bFQ==
MIME-Version: 1.0
In-Reply-To: <m2hb42ki5a.fsf@firstfloor.org>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
	<1316778523.9084.17.camel@twins>
	<20110923122014.GP6063@erda.amd.com>
	<m2hb42ki5a.fsf@firstfloor.org>
Date: Tue, 4 Oct 2011 14:35:38 +0200
Message-ID: <CABPqkBRPvKxkyH6tVK1AQDBTbyrE3Cy0wjz64qaE2p0dzPRYig@mail.gmail.com>
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 24, 2011 at 12:28 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Robert Richter <robert.richter@amd.com> writes:
> >
> > I think we could extend perf report to parse also ibs samples. The
> > only thing we need for it should be the pmu name/type mapping in the
> > perf.data header and the pmu type in the sample. See my comment on
> > Stephane's patch '[PATCH] perf: make perf.data more self-descriptive
> > (v5)'.
>
> I would like to have a similar user tool for Intel PEBS data.
>
> I have some hacks currently to dump more data from the PEBS record and
> it's useful for some situations. I was actually thinking of adapting
> Robert's tool, but integrating it into other tools is fine too.
>
There is Lin Ming's patch to expose PEBS Load Latency information.
I will post a patch to export more of the machine state later on.

> Sometimes a "perf print-samples" to print individual samples
> would be useful too  (it's already possible with -R, but very unfriendly
> without post processing)
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
