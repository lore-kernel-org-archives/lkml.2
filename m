Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab1DVOsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 10:48:47 -0400
Received: from smtp-out.google.com ([74.125.121.67]:9141 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab1DVOsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 10:48:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tvWwMy2V2yeNGhyKVNLs1hJPqSfb3IiDeFsemfNtn+1jSH2K8wepZvjox7v8wigOhx
         rTaSc80rpmVmlTtRI+EA==
MIME-Version: 1.0
In-Reply-To: <1303483678.4865.0.camel@laptop>
References: <BANLkTinNJERr_=ELO61UbrwCJjW1KAdK2A@mail.gmail.com>
	<1303478798.2461.11.camel@localhost>
	<BANLkTimXi0on1pLLqeW3C3YyKXNeyE1d5Q@mail.gmail.com>
	<1303482702.2461.40.camel@localhost>
	<BANLkTinxzH-3uXXfj4ALzkM48FnQ+shdvg@mail.gmail.com>
	<1303483678.4865.0.camel@laptop>
Date: Fri, 22 Apr 2011 16:48:42 +0200
Message-ID: <BANLkTim7D2sP_80+Zx_KYc041uukrHMU+w@mail.gmail.com>
Subject: Re: perf_events: questions about cpu_has_ht_siblings() and offcore support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lin Ming <ming.m.lin@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "Kleen, Andi" <andi.kleen@intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 4:47 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-04-22 at 16:41 +0200, Stephane Eranian wrote:
>> I assume that's because hotplug
>> cpu is inherently serialized. You cannot have a CPU going offline
>> and one going online at the same time. is that right?
>
> Exactly, that's all serialized under the hotpug mutex
>
Ok, thanks.
