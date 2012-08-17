Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab2HQNie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:38:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33254 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2HQNiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:38:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120816212249.GH24861@google.com>
References: <1345040741-5508-1-git-send-email-js1304@gmail.com>
	<20120816212249.GH24861@google.com>
Date: Fri, 17 Aug 2012 22:38:24 +0900
Message-ID: <CAAmzW4Pvn4m2mcEu0ezKYk815ntDzvTOFVYrhM3T9jhoTx-Dzg@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] system_highpri_wq
From: JoonSoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/17 Tejun Heo <tj@kernel.org>:
> On Wed, Aug 15, 2012 at 11:25:35PM +0900, Joonsoo Kim wrote:
>> Change from v2
>> [1/6] No change
>> [2/6] Change local variable name and use it directly for TP
>> [3/6] Add a comment.
>> [4/6] No change
>> [5/6] Add a comment. Fix ugly indentation.
>> [6/6] No change
>>
>> Change from v1
>> [ALL] Add cover-letter
>> [ALL] Rebase on git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.7
>>
>> [1/6] No change
>> [2/6] First added into this series.
>> [3/6] Add change log to clarify what pacth do,
>>       Add logic to handle the case "@cpu is WORK_CPU_UNBOUND"
>> [4/6] Fix awsome mistake: Set WQ_HIGHPRI for system_highpri_wq
>> [5/6] Adopt Tejun's comment about selection system_wq
>> [6/6] No change
>>
>> This patchset introduce system_highpri_wq
>> in order to use proper cwq for highpri worker.
>>
>> First 3 patches are not related to that purpose.
>> Just fix arbitrary issues.
>> Last 3 patches are for our purpose.
>
> Applied to wq/for-3.7 w/ minor updates.
>
> Thanks.
>
> --
> tejun

Hello.
I checked your minor update and it looks better.
Sorry for my poor explanation for patches.

Thank you very much.
