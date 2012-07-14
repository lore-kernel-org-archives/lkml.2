Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab2GNNjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 09:39:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46726 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab2GNNjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 09:39:14 -0400
References: <1342202575.2706.4.camel@offbook> <20120714101951.GB26559@liondog.tnic>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120714101951.GB26559@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86, amd: rename vmmu support capability
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 14 Jul 2012 15:38:26 +0200
To: Borislav Petkov <bp@alien8.de>, Davidlohr Bueso <dave@gnu.org>
CC: Ingo Molnar <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, x86@kernel.org
Message-ID: <0ffa7987-66fd-4c8d-85da-9911eee3eeaf@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yep, NAK on this one.

Borislav Petkov <bp@alien8.de> wrote:

>On Fri, Jul 13, 2012 at 08:02:55PM +0200, Davidlohr Bueso wrote:
>> From: Davidlohr Bueso <dave@gnu.org>
>> 
>> AMD has renamed nested page table technology to rapid virtualization
>indexing,
>> reflect this change in the kernel.
>> 
>> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
>
>You know that /proc/cpuinfo is a userspace ABI, right?
>
>And are you sure nothing is using that string -
>"npt" - since it got added almost three years ago by
>414bb144efa2d2fe16d104d836d0d6b6e9265788?
>
>-- 
>Regards/Gruss,
>    Boris.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
