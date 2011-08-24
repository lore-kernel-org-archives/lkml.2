Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab1HXJnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:43:21 -0400
Received: from david.siemens.de ([192.35.17.14]:28092 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124Ab1HXJnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:43:19 -0400
X-Greylist: delayed 1545 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Aug 2011 05:43:19 EDT
Message-ID: <4E54C179.2090608@siemens.com>
Date: Wed, 24 Aug 2011 11:16:41 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] KVM: Add wrapper script around Qemu to test kernels
References: <1314137806-5747-1-git-send-email-agraf@suse.de> <4E54B590.9040408@redhat.com>
In-Reply-To: <4E54B590.9040408@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-24 10:25, Avi Kivity wrote:
> On 08/24/2011 01:16 AM, Alexander Graf wrote:
>> +"
>> +echo "\
>> +Your guest is bound to the current foreground shell. To quit the guest,
>> +please use Ctrl-A x"
>> +echo "  Executing: $QEMU_BIN $QEMU_OPTIONS -append \"$KERNEL_APPEND\"
>> -smp $SMP"
>> +echo
>> +
>> +exec $QEMU_BIN $QEMU_OPTIONS -append "$KERNEL_APPEND -smp $SMP"
> 
> Would be nice to support launching gdb in a separate terminal with
> vmlinux already loaded, and already attached to qemu.

+ loading a python script into gdb to pull in module symbols. There are
a few implementations floating around (including my own one).

It would also be nice if one could append QEMU (note the capitalization
BTW) options to the script, maybe everything after a '--' separator.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
