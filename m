Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0FRDEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 23:04:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56049 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab0FRDEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 23:04:30 -0400
X-User-Agent: K-9 Mail for Android
References: <20100617221318.GC24749@outflux.net>,<4C1AA15E.3050205@zytor.com> <SNT125-W601D37A89A8CBFFDFFF40EC3C00@phx.gbl>
In-Reply-To: <SNT125-W601D37A89A8CBFFDFFF40EC3C00@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: RE: [PATCH] x86: clear XD_DISABLED flag on Intel to regain NX
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 17 Jun 2010 20:03:48 -0700
To: Yuhong Bao <yuhongbao_386@hotmail.com>, kees.cook@canonical.com
CC: x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       mingo@redhat.com, tabbott@ksplice.com, sam@ravnborg.org,
       heukelum@fastmail.fm
Message-ID: <c426f516-7a1c-49bd-a05e-da98171f1c5a@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I mentally flipped the sense of the bit... talked to Kees already.

"Yuhong Bao" <yuhongbao_386@hotmail.com> wrote:

>
>> a) Not all Intel CPUs with extended CPUID levels have
>> MSR_IA32_MISC_ENABLE bit 34. Since we can't take traps here we would
>> have to know positively that we aren't going to trip on anything.
>It won't as these older Intel CPUs are always going to read this bit as zero, and even if no checking for this is include all the wrmsr would do is write the same value back, which won't cause a trap.
>
>Yuhong Bao
> 		 	   		  
>_________________________________________________________________
>Hotmail has tools for the New Busy. Search, chat and e-mail from your inbox.
>http://www.windowslive.com/campaign/thenewbusy?ocid=PID28326::T:WLMTAGL:ON:WL:en-US:WM_HMP:042010_1

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
