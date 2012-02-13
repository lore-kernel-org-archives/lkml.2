Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab2BMSQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 13:16:04 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36171 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab2BMSQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 13:16:01 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVj12UCGbOe4wZfx-L8tdab-1si-RA=vBnNeZ7cUNqyyg@mail.gmail.com>
References: <tip-d9bc9be89629445758670220787683e37c93f6c1@git.kernel.org>
	<CAE9FiQWRjvu_uNcx_bJXYHeg4D4k6YzHHmSudsq7EyubLi7+nw@mail.gmail.com>
	<m1ipjc3fsk.fsf@fess.ebiederm.org>
	<CAE9FiQVLnyRB+pAqi22C5mCbHOOVKxsBhQKaB6P0p9f2LBL8bA@mail.gmail.com>
	<m1zkcmyjyd.fsf@fess.ebiederm.org>
	<CAE9FiQVj12UCGbOe4wZfx-L8tdab-1si-RA=vBnNeZ7cUNqyyg@mail.gmail.com>
Date: Mon, 13 Feb 2012 10:16:00 -0800
X-Google-Sender-Auth: duI1l9GBI-I5LQhbNKXc32GaeMk
Message-ID: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com>
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in
 crash path
From: Yinghai Lu <yinghai@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        torvalds@linux-foundation.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 8:51 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> So I suspect we have a bug in our apic initialization somewhere, but
>> apic initialization should happen after printk are enabled.  Or at least
>> after early printks so the reset YH is reporting doesn't make much sense.
>
> will try Don's first version patch that only removing disable_IO_APIC.

first version patch (only removing disable_IO_APIC) is working.

Thanks

Yinghai
