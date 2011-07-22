Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab1GVVOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:14:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24829 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab1GVVOa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:14:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=fUgh31hL49dz1jSgjymyy1sf+zLXj/b6PKDM6ydNEbciovx6Pv8b+ALt/3w91g8Er
	NtkQ/xi4XSE9FO+BoX4vA==
MIME-Version: 1.0
In-Reply-To: <20110722210114.GT8006@one.firstfloor.org>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	<CABPqkBTznHwX_i=sraOkAkyAdX48fi3zVMa_M+Wdp09WMkQeoQ@mail.gmail.com>
	<20110722210114.GT8006@one.firstfloor.org>
Date: Fri, 22 Jul 2011 14:14:26 -0700
Message-ID: <CABPqkBQP7VNZBFj2h_TA67rr_QL7oxj1p8CjzG+faBd2m0dQig@mail.gmail.com>
Subject: Re: [PATCH 0/4] perf: memory load/store events generalization
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 2:01 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> That looks okay as a first approach tool. But what people are most
>> often interested in is to see where the misses occur, i.e., you need
>> to display load/store addresses somehow, especially for the more
>
> But that's what it already does?  (for loads, stores
> are not in there yet) Did you try it?
>
I meant displaying the load + data addresses.
I have not tried it yet, just looked at the patches.

> Or did you mean resolving the addresses? While I agree that would
> be useful that's a quite big task and I don't think it should
> be blocked on that.
>
I agree with you, just wanted to check on the longer term goal.
