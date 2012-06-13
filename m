Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab2FMNKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:10:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61530 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab2FMNKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:10:12 -0400
MIME-Version: 1.0
In-Reply-To: <1339592667.8980.32.camel@twins>
References: <CABPqkBQa8ndydqkMDvc3kzu84_96FbK77TUkrfO3eSPXmv3dhQ@mail.gmail.com>
	<1339592667.8980.32.camel@twins>
Date: Wed, 13 Jun 2012 15:10:10 +0200
Message-ID: <CABPqkBTM7xcy_BdB2cHL4cvbk0wihB1PonC4nZCSxiNtkMyX4Q@mail.gmail.com>
Subject: Re: [BUG] perf: perf_output_sample() merge issue?
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 3:04 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-06-13 at 14:51 +0200, Stephane Eranian wrote:
>> I think the intent of this commit was to add the watermark check
>> at the very end of the perf_output_sample() and NOT between processing
>> of RAW and BRANCH_STACK. Something may have gone wrong
>> in the merge.
>>
>> Can you confirm this?
>
> Yes very much so, good spotting. Weird stuff this merging.

Ok, so I will post a patch to fix that then.
