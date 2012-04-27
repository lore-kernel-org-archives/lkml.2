Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760706Ab2D0QX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:23:56 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42131 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760389Ab2D0QXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:23:55 -0400
MIME-Version: 1.0
In-Reply-To: <1335543660.13683.113.camel@twins>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
	<1333390758-10893-7-git-send-email-robert.richter@amd.com>
	<1334398906.2528.49.camel@twins>
	<20120423095659.GS9747@erda.amd.com>
	<20120427123434.GF18810@erda.amd.com>
	<CABPqkBS9FNmHBukzJqGJP1r5iqyLL9gz2g=3jvnt22pDxOdndA@mail.gmail.com>
	<20120427125410.GG18810@erda.amd.com>
	<1335540633.2463.133.camel@laptop>
	<20120427160922.GI18810@erda.amd.com>
	<1335543660.13683.113.camel@twins>
Date: Fri, 27 Apr 2012 18:23:53 +0200
Message-ID: <CABPqkBRSm0NkyHPE5ZCo0_NkB4Aevv+YB4_qqW7nVDe9mwSURw@mail.gmail.com>
Subject: Re: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 6:21 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2012-04-27 at 18:09 +0200, Robert Richter wrote:
>>
>> But do you agree to have level 1 and 2 mapped to ibs, not just only
>> level 2 (since I don't want to fail with r076:p)?
>
> Sure, you can have 1 and 2 mean the same. 2 wants 0 skid, 1 wants
> constant skid, 0 is a constant, therefore its consistent.

Yes. With IBS I would expect no difference in the samples between
level  1 and 2. But that's okay. As Peter says, it still fits within the
definitions of those levels.
