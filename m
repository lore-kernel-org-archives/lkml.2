Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab2LWOeO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 09:34:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52378 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab2LWOeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 09:34:11 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQV5QqONiTdnHzsjVRTbnEfyHEE3s=-=+a49F2a5se7K+A@mail.gmail.com>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org> <20121222024225.GG3468@phenom.dumpdata.com> <eee81bb9-f11b-4ff8-8a84-72f122766fd8@email.android.com> <20121222132419.GB2936@phenom.dumpdata.com> <CAE9FiQV5QqONiTdnHzsjVRTbnEfyHEE3s=-=+a49F2a5se7K+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading ramdisk and bzImage above 4G
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 23 Dec 2012 06:33:38 -0800
To: Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <6214ad82-5b7e-47f2-a9c1-98972bdee517@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Explanation please?

Yinghai Lu <yinghai@kernel.org> wrote:

>On Sat, Dec 22, 2012 at 5:24 AM, Konrad Rzeszutek Wilk
><konrad.wilk@oracle.com> wrote:
>>
>> Interestingly enough I only see this on any AMD machine - different
>> motherboards, different memory configurations.
>>
>> And also in a HVM guest running on an AMD machine. If it runs on
>Intel
>> it works just fine.
>
>Found the reason,
>
>-v11: change far jmp back to far return to initial_code, that is needed
>     to fix failure that is reported by Konard on AMD system.
>
>works well on on AMD 4 sockets that I found.
>
>update the for-x86-boot branch, please check that.
>git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>for-x86-boot
>
>Thanks a lot for the testing on AMD system.
>
>Yinghai

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
