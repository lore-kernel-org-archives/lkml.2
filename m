Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab1JDNUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 09:20:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32365 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab1JDNUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 09:20:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=LJXPsbSMgMwyB+xl99B8cHLboa38gOMLhVl/RbAHr813xsAbUMWN3RfN5xhkezoWq
	O2HLzRGfMmgmluxDVLkJg==
MIME-Version: 1.0
In-Reply-To: <20111004131800.GD14482@one.firstfloor.org>
References: <1316597423-25723-1-git-send-email-robert.richter@amd.com>
	<1316778523.9084.17.camel@twins>
	<20110923122014.GP6063@erda.amd.com>
	<m2hb42ki5a.fsf@firstfloor.org>
	<CABPqkBRPvKxkyH6tVK1AQDBTbyrE3Cy0wjz64qaE2p0dzPRYig@mail.gmail.com>
	<20111004131800.GD14482@one.firstfloor.org>
Date: Tue, 4 Oct 2011 15:20:08 +0200
Message-ID: <CABPqkBSbe4pcrJ_h9XdXt7_8kxByT-fVOkquDf--vJnk+w8Fkw@mail.gmail.com>
Subject: Re: [V3][PATCH 0/7] perf, x86: Implement AMD IBS
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 4, 2011 at 3:18 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> There is Lin Ming's patch to expose PEBS Load Latency information.
>> I will post a patch to export more of the machine state later on.
>
> I have some patches to expose LBR and raw PEBS (similar to Robert's
> IBS patches, just for PEBS). But the user code still needs more work for that.
>
I will post a complete patch to abstract LBR and update perf accordingly.
I am updating it to 3.1.0-rc8. Will post later this week.
