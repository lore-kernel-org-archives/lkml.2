Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3AGMkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 07:40:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53856 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab3AGMkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 07:40:08 -0500
Date: Mon, 7 Jan 2013 13:40:05 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 03/31] x86, realmode: set real_mode permissions early
Message-ID: <20130107124005.GA5954@liondog.tnic>
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
 <1357260531-11115-4-git-send-email-yinghai@kernel.org>
 <20130104201516.GA24228@x1.alien8.de>
 <CAE9FiQWvp7UPY7f33B9cG05S4ALCN-ezMi2N=-z++9w-Dp_+ZQ@mail.gmail.com>
 <20130104210407.GB24228@x1.alien8.de>
 <CAE9FiQXBCtCGAZ33RqwG8+hD+NxB0a7KJxU0gKbe0A=TTi-B4Q@mail.gmail.com>
 <20130105132546.GE4297@x1.alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130105132546.GE4297@x1.alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 02:25:46PM +0100, Borislav Petkov wrote:
> Or do you mean that the function naming is wrong? WTF?

Ok, I think I can guess what you mean: that's setup_real_mode which
allocates the real_mode_blob memory. Right?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
