Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0KOLDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 06:03:34 -0500
Received: from smtp-out.google.com ([74.125.121.35]:31703 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab0KOLDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 06:03:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uzHibvTKBtrtZVwa+MyYob4fVMI5No4E9/2hp0MwcMHG0D3KQCJKXqXodq+z1u3ZO0
         zR9cR7XPLB2EqxllkYmA==
MIME-Version: 1.0
In-Reply-To: <1289644462.2084.528.camel@laptop>
References: <1289580941-29744-1-git-send-email-andi@firstfloor.org>
	<AANLkTimJ3nLwmRfmf+uTuUvg6HVrHBzrjgQXuTi5dxyp@mail.gmail.com>
	<1289583192.2084.339.camel@laptop>
	<20101113101753.GE6418@gargoyle.fritz.box>
	<1289644462.2084.528.camel@laptop>
Date: Mon, 15 Nov 2010 12:03:28 +0100
Message-ID: <AANLkTikr-rOYALdUiRDFahqE1GECO5XNKnbN9LNZBebU@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf-events: Add support for supplementary event
 registers v2
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu, fweisbec@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 11:34 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Sat, 2010-11-13 at 11:17 +0100, Andi Kleen wrote:
>> > That would assume a single event doesn't contain offcore and lbr, no?
>> > Currently the extra_reg thing assumes there's only one extra reg encoded
>> > in the config word.
>>
>> It would not be too hard to make it an array if that's needed.
>
> I don't think we want to go there anyway, one extra_reg per config value
> is fine.
>
I think offcore goes into .config, lbr goes into extra_reg. That should take
care of combinations as well.
