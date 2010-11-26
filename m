Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0KZNHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 08:07:33 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48246 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab0KZNHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:07:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=pWmClrZl0mpT1Qss959sTSgugiGSz+zCJcrAlu0FhjaGzV2yry+uK8xR9ZObqJQXuA
         JXYPYsQRuph8RYMKNMi4MqSja2BEVOa+Uxux9eSzgJ15xQop9XofYwQ7SRo6nkfWd/NO
         n6TqXP7n7DAJ2gj+KKC/9bFKT8zEtJ8llmpkA=
MIME-Version: 1.0
In-Reply-To: <1290776379.2145.143.camel@laptop>
References: <20101123224601.766827604@openvz.org>
	<20101123224800.294919307@openvz.org>
	<AANLkTikjEDVmQRt4ZxwwXJznX2X3zSqSY=zoPtuN1omY@mail.gmail.com>
	<1290776379.2145.143.camel@laptop>
Date: Fri, 26 Nov 2010 16:07:30 +0300
X-Google-Sender-Auth: Em-DBkFrFyiGXnf_zGLG8RGdz9k
Message-ID: <AANLkTik6cO+0pLQy0+YXgzEVo1bC0-6_Pemu81P95Yej@mail.gmail.com>
Subject: Re: [rfc 1/3] perf, x86: P4 PMU - describe config format
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, ming.m.lin@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/10, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-11-26 at 13:48 +0100, Stephane Eranian wrote:
>> Reviewed-by: Stephane Eranian <eranian@google.com>
>
> The new one, right? The one that reads:
>

yes, it's updated

> + *    Low 32 bits
> + *    -----------
> + *      0-6: P4_PEBS_METRIC enum
> + *     7-11:                    reserved
> + *       12:                    reserved (Enable)
> + *    13-15:                    reserved (ESCR select)
> + *    16-17: Active Thread
> + *       18: Compare
> + *       19: Complement
> + *    20-23: Threshold
> + *       24: Edge
> + *       25:                    reserved (FORCE_OVF)
> + *       26:                    reserved (OVF_PMI_T0)
> + *       27:                    reserved (OVF_PMI_T1)
> + *    28-29:                    reserved
> + *       30:                    reserved (Cascade)
> + *       31:                    reserved (OVF)
> + *
> + *    High 32 bits
> + *    ------------
> + *        0:                    reserved (T1_USR)
> + *        1:                    reserved (T1_OS)
> + *        2:                    reserved (T0_USR)
> + *        3:                    reserved (T0_OS)
> + *        4: Tag Enable
> + *      5-8: Tag Value
> + *     9-24: Event Mask (may use P4_ESCR_EMASK_BIT helper)
> + *    25-30: enum P4_EVENTS
> + *       31:                    reserved (HT thread)
>
>
