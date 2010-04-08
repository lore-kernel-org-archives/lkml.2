Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933662Ab0DHVdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:33:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2529 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038Ab0DHVdS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:33:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=v64FVAL1iSDqiIshq5thU4kkt8PnPqTcB2FRi5ikZXdWkgdIE51J3khjX0pvKYPq3
	mWAAzMBUJAT+WtpzFW85w==
MIME-Version: 1.0
In-Reply-To: <1270761860.20295.3162.camel@laptop>
References: <4bbe4175.5124cc0a.5bd3.22d6@mx.google.com>
	 <1270760136.20295.3121.camel@laptop>
	 <1270760599.20295.3144.camel@laptop>
	 <w2ibd4cb8901004081418zf82adbfcu21316a5c8483b755@mail.gmail.com>
	 <1270761860.20295.3162.camel@laptop>
Date: Thu, 8 Apr 2010 23:33:15 +0200
Message-ID: <v2lbd4cb8901004081433l7bff8d3cq2f11ca6c222e8e87@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix bogus warn_on(_once) in 
	perf_prepare_sample()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       davem@davemloft.net, fweisbec@gmail.com, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 11:24 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-04-08 at 23:18 +0200, Stephane Eranian wrote:
>> I am not sure I understand what you mean by buffered PEBS. Are you talking
>> about using PEBS buffer bigger than one entry?
>
> Yep.
>
>> If so, how can you do:
>>   - the LBR based fixups for multiple samples (on PMU interrupt)
>
> Not, so it would be the offset on.
>
Not sure I understand what you mean here.

>>   - attribute PID/TID in system-wide mode
>
> flush on context switches.
>
cost?
