Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1HXVGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 17:06:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40875 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab1HXVGO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 17:06:14 -0400
Subject: Re: [PATCH] KVM: Add wrapper script around Qemu to test kernels
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4E54C179.2090608@siemens.com>
Date: Wed, 24 Aug 2011 16:06:08 -0500
Cc: Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Pekka Enberg <penberg@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <87E1B96A-24EB-41A1-985C-9F078D0B78F3@suse.de>
References: <1314137806-5747-1-git-send-email-agraf@suse.de> <4E54B590.9040408@redhat.com> <4E54C179.2090608@siemens.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 24.08.2011, at 04:16, Jan Kiszka wrote:

> On 2011-08-24 10:25, Avi Kivity wrote:
>> On 08/24/2011 01:16 AM, Alexander Graf wrote:
>>> +"
>>> +echo "\
>>> +Your guest is bound to the current foreground shell. To quit the guest,
>>> +please use Ctrl-A x"
>>> +echo "  Executing: $QEMU_BIN $QEMU_OPTIONS -append \"$KERNEL_APPEND\"
>>> -smp $SMP"
>>> +echo
>>> +
>>> +exec $QEMU_BIN $QEMU_OPTIONS -append "$KERNEL_APPEND -smp $SMP"
>> 
>> Would be nice to support launching gdb in a separate terminal with
>> vmlinux already loaded, and already attached to qemu.
> 
> + loading a python script into gdb to pull in module symbols. There are
> a few implementations floating around (including my own one).

I'll leave that part to you then :). I haven't figured out a nice way how to get modules into the VM for now anyways.

> It would also be nice if one could append QEMU (note the capitalization
> BTW) options to the script, maybe everything after a '--' separator.

Good point :)


Alex

