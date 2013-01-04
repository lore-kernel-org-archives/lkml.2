Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab3ADVEA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:04:00 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54701 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733Ab3ADVD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:03:58 -0500
Date: Fri, 4 Jan 2013 22:04:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 03/31] x86, realmode: set real_mode permissions early
Message-ID: <20130104210407.GB24228@x1.alien8.de>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQWvp7UPY7f33B9cG05S4ALCN-ezMi2N=-z++9w-Dp_+ZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 12:58:15PM -0800, Yinghai Lu wrote:
> more than that, that set_real_mode_permissions reference is wrong,
> actually it is set_real_mode.

Huh, set_real_mode_permissions is the name of the function above which the
comment is located. There's no set_real_mode. What do you mean?

-- 
Regards/Gruss,
Boris.
