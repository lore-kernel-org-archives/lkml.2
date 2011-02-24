Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab1BXJzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 04:55:01 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:55136 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172Ab1BXJy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 04:54:59 -0500
Message-ID: <4D662AE5.3090400@free.fr>
Date: Thu, 24 Feb 2011 10:54:45 +0100
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
Subject: Re: [PATCH 1/4] userns: let clone_uts_ns() handle setting uts->user_ns
References: <20110221040156.GA12580@mail.hallyn.com> <20110224002141.GA27640@mail.hallyn.com>
In-Reply-To: <20110224002141.GA27640@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 01:21 AM, Serge E. Hallyn wrote:
> To do so we need to pass in the task_struct who'll get the utsname,
> so we can get its user_ns.
>
> Changelog:
> 	Feb 23: As per Oleg's coment, just pass in tsk.
>
> Signed-off-by: Serge E. Hallyn<serge.hallyn@canonical.com>

Acked-by: Daniel Lezcano <daniel.lezcano@free.fr>

