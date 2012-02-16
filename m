Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab2BPSnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:43:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41116 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab2BPSnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:43:07 -0500
MIME-Version: 1.0
In-Reply-To: <20120216025331.GT9751@redhat.com>
References: <tip-d9bc9be89629445758670220787683e37c93f6c1@git.kernel.org>
	<CAE9FiQWRjvu_uNcx_bJXYHeg4D4k6YzHHmSudsq7EyubLi7+nw@mail.gmail.com>
	<20120213152808.GD9751@redhat.com>
	<CAE9FiQXX7BXKuVHZ9NRCEmeTnPj4zVJL5gf5eSp6b+4e3jN3EA@mail.gmail.com>
	<20120216025331.GT9751@redhat.com>
Date: Thu, 16 Feb 2012 10:43:06 -0800
X-Google-Sender-Auth: 0YHre0MtiqHZOdPrSwDnZVxO2cg
Message-ID: <CAE9FiQW4utm0roHR7zHS_tHbOAhqi4SECjH8cwJ3H=zEKhQLXA@mail.gmail.com>
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in
 crash path
From: Yinghai Lu <yinghai@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, ebiederm@xmission.com, akpm@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 6:53 PM, Don Zickus <dzickus@redhat.com> wrote:
>
> For some reason using gzip instead of xz makes things work for me with
> your config.
>
> CONFIG_KERNEL_GZIP=y
> CONFIG_KERNEL_XZ=n
>
> Do you see the same thing?

no.

with GZIP still get instant reset.

Yinghai
