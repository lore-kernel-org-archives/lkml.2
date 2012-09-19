Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab2ISDms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 23:42:48 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59583 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474Ab2ISDmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 23:42:46 -0400
MIME-Version: 1.0
In-Reply-To: <1348025233-13412-1-git-send-email-hongfeng@marvell.com>
References: <1348025233-13412-1-git-send-email-hongfeng@marvell.com>
Date: Tue, 18 Sep 2012 20:42:44 -0700
X-Google-Sender-Auth: _5pMzic0pmKHKoRrueoF6YCZHPs
Message-ID: <CAGXu5jKP-df8SrWD-ActWExWBRqJaajQ=5BKiRgHp8tvk3EA_w@mail.gmail.com>
Subject: Re: [PATCH] poweroff: fix bug in orderly_poweroff
From: Kees Cook <keescook@chromium.org>
To: hongfeng <hongfeng@marvell.com>
Cc: akpm@linux-foundation.org, gorcunov@openvz.org, serge.hallyn@canonical.com,
        ebiederm@xmission.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 8:27 PM, hongfeng <hongfeng@marvell.com> wrote:
> orderly_poweroff is trying to poweroff platform by two steps:
> step 1: Call userspace application to poweroff
> step 2: If userspace poweroff fail, then do a force power off if force param is set.
>
> The bug here is, step 1 is always successful with param UMH_NO_WAIT,
> should change to UMH_WAIT_PROC which will monitor the return value ofuserspace application.
>
> Signed-off-by: Feng Hong <hongfeng@marvell.com>

Seems right to me.

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
