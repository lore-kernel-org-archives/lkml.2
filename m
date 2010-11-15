Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab0KOLAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 06:00:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:18693 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab0KOLAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 06:00:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nX3e7YOv/7sQ/qvlGW9qU3Hq88ze9AOvcOQfPrnhCfR/6oNNWOs1Kiwp5UkZjmEvy2
         t8xIWvPWLd9IQp0XaJnA==
MIME-Version: 1.0
In-Reply-To: <20101113101753.GE6418@gargoyle.fritz.box>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
	<AANLkTimJ3nLwmRfmf+uTuUvg6HVrHBzrjgQXuTi5dxyp@mail.gmail.com>
	<1289583192.2084.339.camel@laptop>
	<20101113101753.GE6418@gargoyle.fritz.box>
Date: Mon, 15 Nov 2010 12:00:29 +0100
Message-ID: <AANLkTimdJRiHHsggNgLqPqSnSNAUwtmShuV0LEjKxi7z@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf-events: Add support for supplementary event
 registers v2
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu, fweisbec@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 11:17 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> > That would assume a single event doesn't contain offcore and lbr, no?
> > Currently the extra_reg thing assumes there's only one extra reg encoded
> > in the config word.
>
> It would not be too hard to make it an array if that's needed.
>
> Before going fancy I would prefer to include the plain base patch
> first though.
>
I agree. Let's do offcore first.
