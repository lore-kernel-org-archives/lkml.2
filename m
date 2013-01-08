Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab3AHXZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:25:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39885 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab3AHXZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:25:38 -0500
Date: Wed, 9 Jan 2013 00:25:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
Message-ID: <20130108232536.GB28869@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20121222024225.GG3468@phenom.dumpdata.com>
 <eee81bb9-f11b-4ff8-8a84-72f122766fd8@email.android.com>
 <20121222132419.GB2936@phenom.dumpdata.com>
 <50D8FBF9.6050509@zytor.com>
 <20121225115226.GD7720@liondog.tnic>
 <e91771a5-0d4e-457b-a3da-f8e855a1baa0@email.android.com>
 <20130108210840.GC23616@liondog.tnic>
 <48eb20be-0b49-43f9-ba73-7ab6849f2bf1@email.android.com>
 <20130108211931.GD23616@liondog.tnic>
 <50ECA91A.4040109@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50ECA91A.4040109@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 03:17:46PM -0800, H. Peter Anvin wrote:
> The only thing that started this was that I got tempted into a
> microoptimization that happens to be valid and documented on Intel,
> but not AMD. Given that it doesn't actually work lretq is probably the
> least insane option.

Well, it would've been good if AMD had implemented the jmp far with
64-bit offset.

And I agree, lretq is way better an option than anything else.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
