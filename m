Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab1HNFKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 01:10:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42505 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab1HNFKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 01:10:20 -0400
References: <20110812150304.GC16880@albatros> <4E45884B.8030303@zytor.com> <20110813062246.GC3851@albatros> <36fcaf94-2e99-47cb-a835-aefb79856429@email.android.com> <m2ei0olnua.fsf@firstfloor.org>
User-Agent: K-9 Mail for Android
In-Reply-To: <m2ei0olnua.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sat, 13 Aug 2011 22:08:57 -0700
To: Andi Kleen <andi@firstfloor.org>
CC: Vasiliy Kulikov <segoon@openwall.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Message-ID: <632d03b0-6725-431e-b100-13f5046b03e9@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:

>"H. Peter Anvin" <hpa@zytor.com> writes:
>>
>> IA64 is totally different.  I'm extremely sceptical to this patch; it
>feels like putting code in a super-hot path to paper over a problem
>that has to be fixed anyway.
>
>Sounds to me a better alternative would be more aggressive, pro-active
>fuzzing of the compat calls.
>
>-Andi
>
>-- 
>ak@linux.intel.com -- Speaking for myself only

Agreed.  Other than that, I can see a fine-grained permission filter, but the compat vs noncompat axis is just spurious.
-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
