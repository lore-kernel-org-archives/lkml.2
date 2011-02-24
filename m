Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab1BXJ5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 04:57:07 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:59879 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172Ab1BXJ5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 04:57:05 -0500
Message-ID: <4D662B64.6030800@free.fr>
Date: Thu, 24 Feb 2011 10:56:52 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@redhat.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH 5/4] Clean up capability.h and capability.c
References: <20110221040156.GA12580@mail.hallyn.com> <20110224002249.GA28659@mail.hallyn.com>
In-Reply-To: <20110224002249.GA28659@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 01:22 AM, Serge E. Hallyn wrote:
> Convert macros to functions to let type safety do its thing.  Switch
> some functions from ints to more appropriate bool.  Move all forward
> declarations together to top of the #ifdef __KERNEL__ section.  Use
> kernel-doc format for comments.
>
> Some macros couldn't be converted because they use functions from
> security.h which sometimes are extern and sometimes static inline,
> and we don't want to #include security.h in capability.h.
>
> Also add a real current_user_ns function (and convert the existing
> macro to _current_user_ns() so we can use it in capability.h
> without #including cred.h.
>
> Signed-off-by: Serge E. Hallyn<serge.hallyn@canonical.com>
> ---

Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>

