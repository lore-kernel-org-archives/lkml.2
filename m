Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3AJMNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:13:19 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35584 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab3AJMNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:13:18 -0500
Date: Thu, 10 Jan 2013 13:13:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 12/31] x86: add get_ramdisk_image/size()
Message-ID: <20130110121315.GE23008@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-13-git-send-email-yinghai@kernel.org>
 <20130107155604.GE29449@x1.alien8.de>
 <CAE9FiQXqgbMiqgfDOnJCsxP4anzgSHfW9aF2cSb3Ko_GoUQB-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQXqgbMiqgfDOnJCsxP4anzgSHfW9aF2cSb3Ko_GoUQB-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 05:53:59PM -0800, Yinghai Lu wrote:
> >> +static u64 __init get_ramdisk_image(void)
> >> +{
> >> +     u64 ramdisk_image = boot_params.hdr.ramdisk_image;
> >> +
> >> +     return ramdisk_image;
> >
> > just do
> 
> No, I will insert line between them.

... and you're going to do this because your code is the best and the
rest can suck it and you don't accept other people's suggestions or...
is there an actual technical reason behind it?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
