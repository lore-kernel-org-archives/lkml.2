Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab3AHXSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:18:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38691 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab3AHXSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:18:18 -0500
Message-ID: <50ECA91A.4040109@zytor.com>
Date: Tue, 08 Jan 2013 15:17:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading ramdisk
 and bzImage above 4G
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org> <20121222024225.GG3468@phenom.dumpdata.com> <eee81bb9-f11b-4ff8-8a84-72f122766fd8@email.android.com> <20121222132419.GB2936@phenom.dumpdata.com> <50D8FBF9.6050509@zytor.com> <20121225115226.GD7720@liondog.tnic> <e91771a5-0d4e-457b-a3da-f8e855a1baa0@email.android.com> <20130108210840.GC23616@liondog.tnic> <48eb20be-0b49-43f9-ba73-7ab6849f2bf1@email.android.com> <20130108211931.GD23616@liondog.tnic>
In-Reply-To: <20130108211931.GD23616@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 01:19 PM, Borislav Petkov wrote:
> On Tue, Jan 08, 2013 at 01:15:41PM -0800, H. Peter Anvin wrote:
>> Yes, but why bother...
>
> I suspected something like that to be the reason after reading into that
> section of the APM of how one needs to jump through hoops to do one
> lousy far jump.
>

The only thing that started this was that I got tempted into a 
microoptimization that happens to be valid and documented on Intel, but 
not AMD.  Given that it doesn't actually work lretq is probably the 
least insane option.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

