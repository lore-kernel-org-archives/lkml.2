Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796Ab1JGKZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:25:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61865 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab1JGKZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:25:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=u1N/y2VIwUAc2nbHAHCy3W5hl/0oLttF8LR0eXrI54behwueaPiS/Zaf1sP27DPWh
	v1PRzhMv7Cv8DyxFOLdsw==
MIME-Version: 1.0
In-Reply-To: <1317927018.9813.5.camel@twins>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	<1317912555-9559-11-git-send-email-eranian@google.com>
	<1317927018.9813.5.camel@twins>
Date: Fri, 7 Oct 2011 12:25:03 +0200
Message-ID: <CABPqkBQta6Vowzh7CNFtS0Ea4dTPMUn9CqUt-jsiasOtGndOWA@mail.gmail.com>
Subject: Re: [PATCH 10/12] perf: add code to support PERF_SAMPLE_BRANCH_STACK
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, andi@firstfloor.org, robert.richter@amd.com,
        ravitillo@lbl.gov
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 8:50 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2011-10-06 at 16:49 +0200, Stephane Eranian wrote:
>
> Is a From: Roberto ..
>
> Line missing here?
>
Yes, I can add it back if that's the way the system works.

>> This patch adds:
>> - ability to parse samples with PERF_SAMPLE_BRANCH_STACK
>> - sort on branches
>> - build histograms on branches
>>
>> Signed-off-by: Roberto Agostino Vitillo <ravitillo@lbl.gov>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>
