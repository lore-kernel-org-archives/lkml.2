Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab2KYLLr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 06:11:47 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34488 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab2KYLLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 06:11:46 -0500
MIME-Version: 1.0
Reply-To: kerolasa@gmail.com
In-Reply-To: <20121120122115.GA2006@x2.net.home>
References: <CAG27Bk1q5t590bvGg7Ka+2M-yWEMk_58sZsOxDKx-1XNn8mHww@mail.gmail.com>
	<20121119161250.ae0b25ff.akpm@linux-foundation.org>
	<20121120122115.GA2006@x2.net.home>
Date: Sun, 25 Nov 2012 11:11:45 +0000
X-Google-Sender-Auth: l-DmL_Ur4WF93HRh8KoNFfDfhK0
Message-ID: <CAG27Bk32JN+9ECaH1CEsSBMqLR3KBUMQ-kZdJQ7SJLO8UxzeoA@mail.gmail.com>
Subject: Re: ipc: object information data in proc and sysfs
From: Sami Kerola <kerolasa@iki.fi>
To: Karel Zak <kzak@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Doug Ledford <dledford@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 12:21 PM, Karel Zak <kzak@redhat.com> wrote:
> On Mon, Nov 19, 2012 at 04:12:50PM -0800, Andrew Morton wrote:
>> Where's the benefit in switching ipcs over to using /proc?
>>
>> procfs reads are probably slower than the syscalls?
>
>  32bit userspace and 64bit kernel (RHEL ppc64), it seems more reliable
>  read from /proc than use the syscalls.
>
>  I guess that IPC_64 flag for shmctl() commands is used by libc in 64bit
>  userspace only.

It seems there is not much interest to have more IPC information
available in user space. Fair enough, and since nothign is exactly
broken so we can live with this.
