Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab2HMRCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:02:33 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34873 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab2HMRCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:02:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120813163601.GC9180@google.com>
References: <1344874672-6257-1-git-send-email-js1304@gmail.com>
	<1344874672-6257-5-git-send-email-js1304@gmail.com>
	<20120813163601.GC9180@google.com>
Date: Tue, 14 Aug 2012 02:02:31 +0900
Message-ID: <CAAmzW4MW_O1LRqJ41zQ47sXAjAyi6U=9LPB=Vbrtj+WhtSU2LQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] workqueue: use system_highpri_wq for unbind_work
From: JoonSoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/14 Tejun Heo <tj@kernel.org>:
> On Tue, Aug 14, 2012 at 01:17:52AM +0900, Joonsoo Kim wrote:
>> To speed cpu down processing up, use system_highpri_wq.
>> As scheduling priority of workers on it is higher than system_wq and
>> it is not contended by other normal works on this cpu, work on it
>> is processed faster than system_wq.
>
> Is this from an actual workload?  ie. do you have a test case where
> this matters?

No. it is not from an actual workload.
I got this idea suddenly, during implementing others.
I will do a test for this tomorrow.
