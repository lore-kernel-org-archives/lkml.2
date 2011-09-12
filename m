Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab1ILOr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:47:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54289 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461Ab1ILOrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:47:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=XpWaFfezl4GzwoxyNSWGrArLkVP6e6J+T3JO6nfh3X+JxIIhGJmB6S4RlTq/4/Jqd
	GYs7snjRR1KDyVyweu5ww==
MIME-Version: 1.0
In-Reply-To: <1315838611.26517.51.camel@twins>
References: <20110907191045.GA13475@quad>
	<4E6E0D0B.3080306@gmail.com>
	<CABPqkBSfQo5E=MJ913E--dc8Fi7VLcFSGNbBf60tOnTLMuVN_w@mail.gmail.com>
	<4E6E181E.9080506@gmail.com>
	<CABPqkBQWd=DyRRDhaxwDGrpCs=XqyTUv72+dn7GKsT=kjPqiJg@mail.gmail.com>
	<1315838611.26517.51.camel@twins>
Date: Mon, 12 Sep 2011 16:47:21 +0200
Message-ID: <CABPqkBSJdCahCugQDyJnoKrB3iFh-yEWNF4Ckm0pRjbcFiKvkA@mail.gmail.com>
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v4)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 4:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-09-12 at 16:40 +0200, Stephane Eranian wrote:
>> I don't think this should be the test to detect endianess.
>
> You should be able to tell the endianness from the PERF_MAGIC string, it
> stores the string as a u64, so depending on endianness it reads back as
> either: PERFFILE or ELIFFREP or whatever the bswap64 result is.
>
right, something like that...
