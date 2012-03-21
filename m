Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567Ab2CUCbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 22:31:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39240 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab2CUCbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 22:31:51 -0400
MIME-Version: 1.0
In-Reply-To: <1332288764-10351-3-git-send-email-konrad.wilk@oracle.com>
References: <1332273919.16101.74.camel@sbsiddha-desk.sc.intel.com>
	<1332288764-10351-1-git-send-email-konrad.wilk@oracle.com>
	<1332288764-10351-3-git-send-email-konrad.wilk@oracle.com>
Date: Tue, 20 Mar 2012 19:31:51 -0700
X-Google-Sender-Auth: 2MJFSczgM1rBt01p3gxb_AZX-Bg
Message-ID: <CAE9FiQVoSTB_zgZ7HeoFpFm6YrxwqRHDCMy3=+N8mf6FfdhNAg@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86/apic_ops: Replace apic_ops with x86_apic_ops.
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: suresh.b.siddha@intel.com, jwboyer@redhat.com, mingo@elte.hu,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 5:12 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> . which makes the code fit within the rest of the x86_ops functions.
> +
> +struct x86_apic_ops x86_apic = {
> +       .init = native_ioapic_init_mappings,
> +       .read = native_ioapic_read,
> +       .write = native_ioapic_write,
> +       .modify = native_ioapic_modify,
> +};

x86_ioapic_ops and x86_ioapic would be better?

Yinghai
