Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab2AHRxq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 12:53:46 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:44864 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417Ab2AHRxl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 12:53:41 -0500
MIME-Version: 1.0
In-Reply-To: <20120108114407.GA22056@parisc-linux.org>
References: <20120107185548.GA30748@outflux.net>
	<20120108114407.GA22056@parisc-linux.org>
Date: Sun, 8 Jan 2012 09:53:38 -0800
X-Google-Sender-Auth: 7sJAC8V7-mmyQP5rSvJwTKbXetQ
Message-ID: <CAGXu5j+ttzBowrrBNXYqtDaQ66C1GUD10dR0oVLiaDxwa5+X3g@mail.gmail.com>
Subject: Re: [PATCH v2012.2] fs: symlink restrictions on sticky directories
From: Kees Cook <keescook@chromium.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>,
        Federica Teodori <federica.teodori@googlemail.com>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 8, 2012 at 3:44 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Sat, Jan 07, 2012 at 10:55:48AM -0800, Kees Cook wrote:
>> v2012.2:
>>  - Change sysctl mode to 0600, suggested by Ingo Molnar.
>>  - Rework CONFIG logic to split code from default behavior.
>>  - Renamed sysctl to have a "sysctl_" prefix, suggested by Andrew Morton.
>
> All the sysctl / CONFIG logic seems very complex.  Why not make it
> a module parameter instead?  It can be easily changed at boot time
> (specify kernel.insecure_symlinks=1 on the kernel command line) and,
> with a mode of 0600, can be modified at runtime too.

Well, I'll still need a CONFIG for the code itself, and the normal way
to tweak kernel operation is via sysctls, so I'd rather not switch to
cmdline options.

-Kees

-- 
Kees Cook
ChromeOS Security
