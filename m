Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab1LFTmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:42:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60873 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1LFTmQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:42:16 -0500
MIME-Version: 1.0
In-Reply-To: <1323119207.32012.33.camel@twins>
References: <1318595833-29984-1-git-send-email-eranian@google.com>
	<1318595833-29984-2-git-send-email-eranian@google.com>
	<1323119207.32012.33.camel@twins>
Date: Tue, 6 Dec 2011 11:42:15 -0800
Message-ID: <CABPqkBSJsiumGoZV73RVJejTeS5SA_T_isBwcZNzucqQ94c6Jw@mail.gmail.com>
Subject: Re: [PATCH 01/12] perf_events: add generic taken branch sampling
 support (v2)
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov, will.deacon@arm.com, paulus@samba.org,
        benh@kernel.crashing.org, rth@twiddle.net, ralf@linux-mips.org,
        davem@davemloft.net, lethal@linux-sh.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 1:06 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-10-14 at 14:37 +0200, Stephane Eranian wrote:
>> @@ -455,6 +483,8 @@ enum perf_event_type {
>>          *
>>          *      { u32                   size;
>>          *        char                  data[size];}&& PERF_SAMPLE_RAW
>> +        *
>> +        *      { u64 from, to, flags } lbr[nr];} && PERF_SAMPLE_BRANCH_STACK
>
>                { u64   nr;
>                  { u64 from, to, flags } brstack[nr]; } && PERF_SAMPLE_BRANCH_STACK
>
> Perhaps? It looks like you lost a line somewhere, even you curly braces
> are unmatched in the correct way.

Yes, that the right way of describing the layout. Will fix that.
