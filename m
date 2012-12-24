Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2LXSoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 13:44:16 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:41036 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2LXSoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 13:44:14 -0500
MIME-Version: 1.0
In-Reply-To: <20121224100457.GA9927@liondog.tnic>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
	<20121222024225.GG3468@phenom.dumpdata.com>
	<eee81bb9-f11b-4ff8-8a84-72f122766fd8@email.android.com>
	<20121222132419.GB2936@phenom.dumpdata.com>
	<CAE9FiQV5QqONiTdnHzsjVRTbnEfyHEE3s=-=+a49F2a5se7K+A@mail.gmail.com>
	<6214ad82-5b7e-47f2-a9c1-98972bdee517@email.android.com>
	<CAE9FiQV-7_wz1jCZh3qDGt6Wq_JN6b1oAyjj3+goCPFnYZ+q9Q@mail.gmail.com>
	<20121223184516.GC8190@liondog.tnic>
	<171018c8-b640-4234-a25e-7040d9e21acd@email.android.com>
	<20121224100457.GA9927@liondog.tnic>
Date: Mon, 24 Dec 2012 10:44:12 -0800
X-Google-Sender-Auth: dnmjtcwQviliJyI1Hq3AyK6ez_Y
Message-ID: <CAE9FiQVwaEJ=uGyMVg33ahNorbDk0AnM83WUJAZ5CENTsgO8Ag@mail.gmail.com>
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 2:04 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Dec 23, 2012 at 08:54:37PM -0800, H. Peter Anvin wrote:
>> Makes sense.  Ljmpq it is.  A comment might be useful.
>
> Yes, a LRETQ comment is definitely useful so that we know. Yinghai,
> please add it the next time you're rebasing. Btw, which branch is the
> current one for that patchset so that people can review and test it?

for-x86-boot and it points to -v8 that does not break KGDB.
