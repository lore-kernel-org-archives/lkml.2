Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab3ADWNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:13:14 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:53352 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab3ADWNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:13:12 -0500
MIME-Version: 1.0
In-Reply-To: <20130104210407.GB24228@x1.alien8.de>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-4-git-send-email-yinghai@kernel.org>
	<20130104201516.GA24228@x1.alien8.de>
	<CAE9FiQWvp7UPY7f33B9cG05S4ALCN-ezMi2N=-z++9w-Dp_+ZQ@mail.gmail.com>
	<20130104210407.GB24228@x1.alien8.de>
Date: Fri, 4 Jan 2013 14:13:11 -0800
X-Google-Sender-Auth: WRmtm6_Y_9RbAwSpQjrjMPMYJ5A
Message-ID: <CAE9FiQXBCtCGAZ33RqwG8+hD+NxB0a7KJxU0gKbe0A=TTi-B4Q@mail.gmail.com>
Subject: Re: [PATCH v7u1 03/31] x86, realmode: set real_mode permissions early
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 4, 2013 at 1:04 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Fri, Jan 04, 2013 at 12:58:15PM -0800, Yinghai Lu wrote:
>> more than that, that set_real_mode_permissions reference is wrong,
>> actually it is set_real_mode.
>
> Huh, set_real_mode_permissions is the name of the function above which the
> comment is located. There's no set_real_mode. What do you mean?

old comments is wrong.

setup_read_mode reserve from low ram under 1M and copy etc.

set_real_mode_permissions will change to +x etc....
