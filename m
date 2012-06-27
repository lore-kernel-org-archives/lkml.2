Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2F0Ryy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:54:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45618 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab2F0Ryw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:54:52 -0400
MIME-Version: 1.0
In-Reply-To: <1340789620-15762-1-git-send-email-chad@dahc.us>
References: <1340789620-15762-1-git-send-email-chad@dahc.us>
Date: Wed, 27 Jun 2012 10:54:50 -0700
X-Google-Sender-Auth: 9x7txtznNBLpXa8ARW6dedzqSRk
Message-ID: <CAGXu5jJ84RxpvGr6LvvyFQwcPW0V1vSz6oUi5gh6h-zQ=P5wAA@mail.gmail.com>
Subject: Re: [PATCH] samples: seccomp: add .gitignore for untracked executables
From: Kees Cook <keescook@chromium.org>
To: Chad Williamson <chad@dahc.us>
Cc: wad@chromium.org, james.l.morris@oracle.com, eparis@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 2:33 AM, Chad Williamson <chad@dahc.us> wrote:
> git status should be clean following make allmodconfig && make. Add
> a .gitignore file to the samples/seccomp directory to ignore binaries
> produced there.
>
> Signed-off-by: Chad Williamson <chad@dahc.us>

Good catch; thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
