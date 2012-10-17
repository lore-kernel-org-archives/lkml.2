Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab2JQEkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 00:40:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34130 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab2JQEkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 00:40:46 -0400
MIME-Version: 1.0
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A1A18B9@SHSMSX101.ccr.corp.intel.com>
References: <1350468706.15558.26.camel@cliu38-desktop-build>
	<CAE9FiQXFvuWS3HPBefUDS+a8VT_2=xtbjFowoPqZcwJSoKt_Hg@mail.gmail.com>
	<27240C0AC20F114CBF8149A2696CBE4A1A18B9@SHSMSX101.ccr.corp.intel.com>
Date: Tue, 16 Oct 2012 21:40:44 -0700
X-Google-Sender-Auth: UKyXx-jK6x2PD28pFDBmdoNklFU
Message-ID: <CAE9FiQUPKP4QpRwoo8ET8P1RSse+KEXMf6j9r4yVJWjbWNzbMQ@mail.gmail.com>
Subject: Re: [PATCH] x86/ioapic: fix the irq_2_pin mem leak when destroy_irq
From: Yinghai Lu <yinghai@kernel.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 8:36 PM, Liu, Chuansheng
<chuansheng.liu@intel.com> wrote:
>> So we can use generic list helper function.
> Does it really need the generic list with both prev and next pointers?
> For irq_2_pin list, the next pointer seems be enough.

generic version should be always better than home grown one.
