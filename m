Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1EWL4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:56:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52974 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab1EWL4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Iu5kcFX0pjvbxS0tAaaTDBuyHG1FhOSvjQbz/xlrvr6D9sSodP5AwRDqqZp/eolf2X
         Xgeu7d5t017fhOAogYIA==
MIME-Version: 1.0
In-Reply-To: <1306149108.18455.13.camel@twins>
References: <20110520143707.GA5347@quad>
	<1306141897.18455.8.camel@twins>
	<1306143168.18455.10.camel@twins>
	<BANLkTimVM2XvpJ1d9SbmAh7xZ+qSjukX+A@mail.gmail.com>
	<BANLkTinN92UpxU85r17zB+Khba8k59nJTA@mail.gmail.com>
	<1306149108.18455.13.camel@twins>
Date: Mon, 23 May 2011 13:56:12 +0200
Message-ID: <BANLkTimiwsHzH6TJY1mP6ORxf4quCkPFkQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] perf_events: update extra shared registers management (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, Lin Ming <ming.m.lin@intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 1:11 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-05-23 at 12:58 +0200, Stephane Eranian wrote:
>> >> event->hw.config &= ~X86_RAW_EVENT_MASK;
>>
>> Not quite, you want INTEL_ARCH_EVENT_MASK instead
>> because you only want to modify umask+event code.
>
> Do EDGE,INV,CMASK actually make a difference for the OFFCORE event?
>
The effect of those filters is independent of the event.
