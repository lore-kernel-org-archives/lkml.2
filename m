Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab1GHMy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 08:54:58 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54077 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1GHMy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 08:54:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110707171627.4f15035e.akpm@linux-foundation.org>
References: <20110707171627.4f15035e.akpm@linux-foundation.org>
Date: Fri, 8 Jul 2011 15:54:56 +0300
Message-ID: <CAGTPOqd-Wid9Pe9z-=YMdzatBHJZJXc39WfRceUFyoi6Kue-ig@mail.gmail.com>
Subject: Re: `make headers_check' bustage
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 8, 2011 at 3:16 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> It is just me, or is headers_check busted in current -linus?
>
> z:/usr/src/25> make mrproper; make allmodconfig; make headers_check
> ...
> /usr/src/25/usr/include/linux/kernel.h:65: userspace cannot reference function or variable defined in the kernel
> /usr/src/25/usr/include/linux/quota.h:175: userspace cannot reference function or variable defined in the kernel
> /usr/src/25/usr/include/linux/sdla.h:116: userspace cannot reference function or variable defined in the kernel
> /usr/src/25/usr/include/linux/soundcard.h:1054: userspace cannot reference function or variable defined in the kernel

Same for me.

soundcard.h issue was not probably fully cleaned up in
43a990765a9e874350bae1009366d00809dbc9d8 (sound: Remove OSSlib stuff
from linux/soundcard.h) checkin.

- Vitaliy
