Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2HVFZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:25:17 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40009 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab2HVFZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:25:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120822025037.GA18807@lizard>
References: <20120822025037.GA18807@lizard>
Date: Tue, 21 Aug 2012 22:25:11 -0700
X-Google-Sender-Auth: hep9MwFbcue1o0ZwDKmMkAMn6gA
Message-ID: <CAGXu5jLr8k8AXJw7UOZFB4J6crmS_Zjm7B-rGAe_V8+X_gcG4A@mail.gmail.com>
Subject: Re: linux-next: New tree -- linux-pstore.git
From: Kees Cook <keescook@chromium.org>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Tony Luck <tony.luck@intel.com>,
        Colin Cross <ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 7:50 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> Hello Stephen,
>
> Can you please add linux-pstore.git tree to the linux-next,
> the repository address is as follows:
>
>   git://git.infradead.org/users/cbou/linux-pstore.git master
>
> This tree is dedicated to track pstore infrastructure fixes and
> enhancements, currently it holds these commits:
>
> Anton Vorontsov (3):
>       pstore/ram: Fix possible NULL dereference
>       pstore/ram: Mark ramoops_pstore_write_buf() as notrace
>       MAINTAINERS: Add pstore maintainers
>
> Jovi Zhang (1):
>       pstore/ram: Add missing platform_device_unregister
>
> Randy Dunlap (1):
>       pstore/ram: Fix printk format warning

FWIW, Acked-by: Kees Cook <keescook@chromium.org> :)

-Kees

-- 
Kees Cook
Chrome OS Security
