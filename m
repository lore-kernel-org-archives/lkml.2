Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab3AENZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 08:25:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41411 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435Ab3AENZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 08:25:30 -0500
Date: Sat, 5 Jan 2013 14:25:46 +0100
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
Message-ID: <20130105132546.GE4297@x1.alien8.de>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQXBCtCGAZ33RqwG8+hD+NxB0a7KJxU0gKbe0A=TTi-B4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 02:13:11PM -0800, Yinghai Lu wrote:
> On Fri, Jan 4, 2013 at 1:04 PM, Borislav Petkov <bp@alien8.de> wrote:
> > On Fri, Jan 04, 2013 at 12:58:15PM -0800, Yinghai Lu wrote:
> >> more than that, that set_real_mode_permissions reference is wrong,
> >> actually it is set_real_mode.
> >
> > Huh, set_real_mode_permissions is the name of the function above which the
> > comment is located. There's no set_real_mode. What do you mean?
> 
> old comments is wrong.
> 
> setup_read_mode reserve from low ram under 1M and copy etc.
> 
> set_real_mode_permissions will change to +x etc....

Ok, let me shout it out to you, hopefully you can understand me now:

THERE ARE NO FUNCTIONS BY THE NAME setup_read_mode OR set_real_mode IN
YOUR BRANCH OR ANYWHERE IN THE KERNEL!!!

$ git log -p yinghai/for-x86-boot-v7 | grep -EriIn '(setup_read_mode|set_real_mode)\W'
$ git log -p yinghai/for-x86-boot-v8 | grep -EriIn '(setup_read_mode|set_real_mode)\W'
$

Or do you mean that the function naming is wrong? WTF?

-- 
Regards/Gruss,
Boris.
