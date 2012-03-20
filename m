Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab2CTONv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:13:51 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60836 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab2CTONt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:13:49 -0400
MIME-Version: 1.0
In-Reply-To: <1332252387.18960.424.camel@twins>
References: <1332249595-2678-1-git-send-email-consul.kautuk@gmail.com>
	<1332252387.18960.424.camel@twins>
Date: Tue, 20 Mar 2012 10:13:49 -0400
Message-ID: <CAFPAmTR53wQRwVCGqe3942GTHVD5zO2Rkvpnk1tR19o7Fm-aow@mail.gmail.com>
Subject: Re: [PATCH 04/20] powerpc/mm/fault.c: Port OOM changes to do_page_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Jimi Xenidis <jimix@pobox.com>,
        Ingo Molnar <mingo@elte.hu>,
        Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        "Mohd. Faris" <mohdfarisq2010@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 10:06 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2012-03-20 at 09:19 -0400, Kautuk Consul wrote:
>> +#ifd#ifdef CONFIG_PPC_SMLPAR
>> +                       if (firmware_has_feature(FW_FEATURE_CMO)) {
>> +                               preempt_disable();
>> +                               get_lppaca()->page_ins += (1 << PAGE_FACTOR);
>> +                               preempt_enable();
>> +                       }
>> +#end#endif
>
> That's curious CPP usage....

Quite baffling.
I don't know how that happened.
I have sent a v2 for this already.
