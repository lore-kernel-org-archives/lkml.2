Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1KHHel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 02:34:41 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39678 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1KHHej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 02:34:39 -0500
X-AuditID: b753bd60-9a062ba00000359c-89-4eb8db8d45d2
X-AuditID: b753bd60-9a062ba00000359c-89-4eb8db8d45d2
Message-ID: <4EB8DB84.6070300@hitachi.com>
Date: Tue, 08 Nov 2011 16:34:28 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 0/5] x86: check stack overflows more reliably
References: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp> <CAOJsxLGH6maRZPx0TX4r6Zy=AiXQMRssoySeOmjn02O-BkBDEA@mail.gmail.com>
In-Reply-To: <CAOJsxLGH6maRZPx0TX4r6Zy=AiXQMRssoySeOmjn02O-BkBDEA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

Thank you for your comments.

(2011/11/07 16:00), Pekka Enberg wrote:
> On Mon, Nov 7, 2011 at 7:51 AM, Mitsuo Hayasaka
> <mitsuo.hayasaka.hu@hitachi.com> wrote:
>> (2) check stack overflow in detail
>>    Currently, only kernel stack is checked for the overflow,
>>    which is not sufficient for enterprise systems. To enhance
>>    reliability, expand stack overflow checking to IRQ and
>>    exception stacks optionally. This is disabled by default
>>    in Kconfig.
> 
> This sounds useful. What's the reason for not enabling this by
> default? Performance regressions?

I'm worried about performance regressions because this patch checks 
a stack overflow in detail.

However, I guess there is no problem for enabling it by default 
since this option is for debug and appears only if a DEBUG_STACKOVERFLOW
option is enabled.

So, I'd like to send the revised patch if it does not have any further problem.


>                         Pekka
> 
> 

