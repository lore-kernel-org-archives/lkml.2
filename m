Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab2FOPZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:25:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54198 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab2FOPZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:25:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120615135647.GC2464@moon>
References: <20120615135647.GC2464@moon>
Date: Fri, 15 Jun 2012 08:25:09 -0700
X-Google-Sender-Auth: 5mmi3SMYX5J4QmWExWXup_cQvXo
Message-ID: <CAGXu5jJqzHrxDK1Yd1+n+0pprpnitdWg_MvjhJxuH4g5kpTXQw@mail.gmail.com>
Subject: Re: [PATCH] c/r: prctl: Move PR_GET_TID_ADDRESS to a proper place
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 6:56 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> During merging of PR_GET_TID_ADDRESS patch the code
> has been misplaced (it happened to appear under PR_MCE_KILL)
> in result noone can use this option.
>
> Fix it by moving code snippet to a proper place.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Good catch!

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
