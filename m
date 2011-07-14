Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab1GNWsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 18:48:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54321 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab1GNWsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 18:48:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=bLcXwPjwZgZKsEEN+FrbGCaExOjbwL/RjVnoqKSvyEmjbYU624TYMlefh75rUBFIp
	VZqOYMsCqpCPKTT553R1Q==
MIME-Version: 1.0
In-Reply-To: <20110714234248.7ed43534@lxorguk.ukuu.org.uk>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <1310675693-9204-2-git-send-email-mikew@google.com> <20110714234248.7ed43534@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Date: Thu, 14 Jul 2011 15:48:23 -0700
Message-ID: <CAGTjWtDHH_VXXAsh5WPspTwPEhzcKi4_Jno7w=jReiS7HSALQw@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 3:42 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 14 Jul 2011 13:34:53 -0700
> Mike Waychison <mikew@google.com> wrote:
>
>> In some build environments, it is useful to allow disabling of IO
>> accesses to hardware, without having to rely on CAP_SYS_RAWIO (which is
>
> And others include mmap and the tty driver and the PCI config space
> (various devices can be manipulated via pci config space to do I/O cycles)
>
> It strikes me that
>
> a) you can do this with a security module

I can?   How?   The whole LSM approach seems intractable to me.

> b) its rather incomplete
>
> and as such you don't need kernel hacks to do it because everything you
> want is already there.

Where?  In an out of tree security module patchset?

>
> Alan
>
