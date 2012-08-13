Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab2HMRwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:52:45 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:48972 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab2HMRwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:52:44 -0400
MIME-Version: 1.0
In-Reply-To: <20120813170745.GH9180@google.com>
References: <1344874672-6257-1-git-send-email-js1304@gmail.com>
	<1344874672-6257-5-git-send-email-js1304@gmail.com>
	<20120813163601.GC9180@google.com>
	<CAAmzW4MW_O1LRqJ41zQ47sXAjAyi6U=9LPB=Vbrtj+WhtSU2LQ@mail.gmail.com>
	<20120813170745.GH9180@google.com>
Date: Tue, 14 Aug 2012 02:52:43 +0900
Message-ID: <CAAmzW4Pw0K0YsjSfJyhTeNUR9b1ihiXr+C5PJh8gXqFRD84WJg@mail.gmail.com>
Subject: Re: [PATCH 5/5] workqueue: use system_highpri_wq for unbind_work
From: JoonSoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/14 Tejun Heo <tj@kernel.org>:
> Hello,
>
> On Tue, Aug 14, 2012 at 02:02:31AM +0900, JoonSoo Kim wrote:
>> 2012/8/14 Tejun Heo <tj@kernel.org>:
>> > On Tue, Aug 14, 2012 at 01:17:52AM +0900, Joonsoo Kim wrote:
>> > Is this from an actual workload?  ie. do you have a test case where
>> > this matters?
>>
>> No. it is not from an actual workload.
>> I got this idea suddenly, during implementing others.
>> I will do a test for this tomorrow.
>
> I don't think it's a bad idea and guess this wouldn't make much
> difference under most workload.  Was mostly wondering whether this
> came from some crazy phone powersave optimization.

Okay.
It is not from an actual workload,
but I intent to optimize some crazy phone powersave :)

Thanks for comments.
