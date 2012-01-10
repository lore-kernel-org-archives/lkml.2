Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2AJKM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:12:58 -0500
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:52964 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab2AJKMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:12:55 -0500
Message-ID: <4F0C0EBB.3090506@tu-ilmenau.de>
Date: Tue, 10 Jan 2012 11:11:07 +0100
From: =?ISO-8859-1?Q?Stephan_B=E4rwolf?= <stephan.baerwolf@tu-ilmenau.de>
Reply-To: stephan.baerwolf@tu-ilmenau.de
Organization: TU-Ilmenau
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111201 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: KVM guest-kernel panics double fault
References: <4EFBC973.1040905@tu-ilmenau.de> <4EFC3B17.1040601@redhat.com> <4F09001D.1050701@tu-ilmenau.de> <4F096E26.4090201@redhat.com>
In-Reply-To: <4F096E26.4090201@redhat.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thank you for your lots of information, they helped very much -
especially debugging...

> The third parameter is actually ecx
(ebx was actually a typing...  ...of course ecx!)

> The emulator is written to be independent of the rest of kvm, using
> emul_to_vcpu() undoes that.  If you need access to more vpcu internals,
> add more function pointers to struct x86_emulate_ops.
I prepare/adapt everything to the mentioned styles/policy.
(I'll insert 2 additional ops for getting "cpuid" and "id of vcpu"...)


> Please post patches separately, not as attachments to a single email. 
> See Documentation/SubmittingPatches.
One thing, which is not fully clear to me: Where exactly should I post
the patches?
Also to/in this mail/group as an empty mail (containing the patch as
text-body) per patch?
Or all (3 patches) at once?
Do you prefer them in a git-repo for example at github?

Again, thank you a lot

regards Stephan

