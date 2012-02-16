Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2BPVmD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 16:42:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993Ab2BPVmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 16:42:00 -0500
Date: Thu, 16 Feb 2012 16:41:41 -0500
From: Don Zickus <dzickus@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-tip-commits@vger.kernel.org, mingo@elte.hu,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, ebiederm@xmission.com, hpa@zytor.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, vgoyal@redhat.com
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in
 crash path
Message-ID: <20120216214141.GG9751@redhat.com>
References: <tip-d9bc9be89629445758670220787683e37c93f6c1@git.kernel.org>
 <CAE9FiQWRjvu_uNcx_bJXYHeg4D4k6YzHHmSudsq7EyubLi7+nw@mail.gmail.com>
 <20120213152808.GD9751@redhat.com>
 <CAE9FiQXX7BXKuVHZ9NRCEmeTnPj4zVJL5gf5eSp6b+4e3jN3EA@mail.gmail.com>
 <20120216025331.GT9751@redhat.com>
 <CAE9FiQW4utm0roHR7zHS_tHbOAhqi4SECjH8cwJ3H=zEKhQLXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQW4utm0roHR7zHS_tHbOAhqi4SECjH8cwJ3H=zEKhQLXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 10:43:06AM -0800, Yinghai Lu wrote:
> On Wed, Feb 15, 2012 at 6:53 PM, Don Zickus <dzickus@redhat.com> wrote:
> >
> > For some reason using gzip instead of xz makes things work for me with
> > your config.
> >
> > CONFIG_KERNEL_GZIP=y
> > CONFIG_KERNEL_XZ=n
> >
> > Do you see the same thing?
> 
> no.
> 
> with GZIP still get instant reset.

What about my other idea, 'echo 0 > /proc/sys/kernel/nmi_watchdog'?

Cheers,
Don
