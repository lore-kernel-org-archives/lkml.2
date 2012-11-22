Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2KVW1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:27:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48228 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836Ab2KVW1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:27:11 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <50AE69EF.4060909@citrix.com>
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com> <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com> <87lidwtego.fsf@xmission.com> <20121121105221.GA2925@host-192-168-1-59.local.net-space.pl> <87txshx28b.fsf@xmission.com> <50AE6542.3020302@zytor.com> <50AE69EF.4060909@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 01/11] kexec: introduce kexec_ops struct
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 22 Nov 2012 14:26:10 -0800
To: Andrew Cooper <andrew.cooper3@citrix.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Message-ID: <09b41677-c9e7-4cd4-84a0-a1cb483d551d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bullshit.  This should be a separate domain.

Andrew Cooper <andrew.cooper3@citrix.com> wrote:

>On 22/11/12 17:47, H. Peter Anvin wrote:
>> The other thing that should be considered here is how utterly 
>> preposterous the notion of doing in-guest crash dumping is in a
>system 
>> that contains a hypervisor.  The reason for kdump is that on bare
>metal 
>> there are no other options, but in a hypervisor system the right
>thing 
>> should be for the hypervisor to do the dump (possibly spawning a
>clean 
>> I/O domain if the I/O domain is necessary to access the media.)
>>
>> There is absolutely no reason to have a crashkernel sitting around in
>
>> each guest, consuming memory, and possibly get corrupt.
>>
>> 	-hpa
>>
>
>I agree that regular guests should not be using the kexec/kdump. 
>However, this patch series is required for allowing a pvops kernel to
>be
>a crash kernel for Xen, which is very important from dom0/Xen's point
>of
>view.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
