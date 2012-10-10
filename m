Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2JJBDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:03:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63748 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755184Ab2JJBDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:03:35 -0400
MIME-Version: 1.0
In-Reply-To: <20121009160133.GF7639@phenom.dumpdata.com>
References: <1349757558-10856-1-git-send-email-yinghai@kernel.org>
	<1349757558-10856-4-git-send-email-yinghai@kernel.org>
	<20121009160133.GF7639@phenom.dumpdata.com>
Date: Tue, 9 Oct 2012 18:03:33 -0700
X-Google-Sender-Auth: t1OYqr76q2kFV3gxpHWZKmWEdF4
Message-ID: <CAE9FiQW8ubsQmtJk=bvZ5yGdBaBQSNWPpuACku+8sbb6_CG+rA@mail.gmail.com>
Subject: Re: [PATCH 03/10] x86, mm: get early page table from BRK
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 9:01 AM, Konrad Rzeszutek Wilk <konrad@kernel.org> wrote:
>> +RESERVE_BRK(early_pgt_alloc, 16384);
>
> How did you come up with 16KB being the right size? What is this
> based on? Can you provide a comment explaining why 16KB is the
> right value on 32-bit and 64-bit machines?

good point, i add one line comment to the revised patch.

+/* need 3 4k for initial PMD_SIZE, 4k for 0-ISA_END_ADDRESS */
