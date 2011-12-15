Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab1LOCkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:40:55 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33286 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab1LOCky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:40:54 -0500
MIME-Version: 1.0
In-Reply-To: <87y5ueo9m5.fsf@abhimanyu.in.ibm.com>
References: <87ehw7ig2v.fsf@abhimanyu.in.ibm.com>
	<alpine.LFD.2.02.1112141423380.3020@ionos>
	<alpine.LFD.2.02.1112142116540.3020@ionos>
	<CAE9FiQXz6n=2gR1CY29pEbfbwx-e27WrUoDQeH9qxmL_kwP+mA@mail.gmail.com>
	<87y5ueo9m5.fsf@abhimanyu.in.ibm.com>
Date: Wed, 14 Dec 2011 18:40:53 -0800
X-Google-Sender-Auth: Uq2y8_mkqx9g4fXiEkEUIc_xYE0
Message-ID: <CAE9FiQXL3N6UZ6REfdUT_o1b-ed_KnYqKm_wSEhsaRPeaE9-9Q@mail.gmail.com>
Subject: Re: Latest tip kernel(3.2-rc1-tip_cf6b3899) fails to boot on x3850x5 machine
From: Yinghai Lu <yinghai@kernel.org>
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 6:24 PM, Nikunj A Dadhania
<nikunj@linux.vnet.ibm.com> wrote:
>>
>> BIOS pre-enabled x2apic, and kernel config does not have x2apic enabled?
> make oldconfig somehow skipped this!! I can see my previous kernel config
> having this enabled.

looks like recent dmar table related DMAR changing cause that.

Yinghai
