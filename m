Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab2GEDAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 23:00:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44015 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab2GEDAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 23:00:00 -0400
MIME-Version: 1.0
In-Reply-To: <1341372710-14648-1-git-send-email-amwang@redhat.com>
References: <20120703152739.ea7df9e6.akpm@linux-foundation.org>
	<1341372710-14648-1-git-send-email-amwang@redhat.com>
Date: Wed, 4 Jul 2012 19:59:58 -0700
X-Google-Sender-Auth: SX-rsn8kY4Dr97lDmfM4COG-zBI
Message-ID: <CAGXu5jKjTcOdZLFa=weSNne8dn5s3xC3cy1DixFzC6Wmm1aHZA@mail.gmail.com>
Subject: Re: [Patch] kernel/sys.c: fix an incorrect error branch in orderly_poweroff()
From: Kees Cook <keescook@chromium.org>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 8:31 PM, Cong Wang <amwang@redhat.com> wrote:
> From: WANG Cong <xiyou.wangcong@gmail.com>
>
> When argv_split() fails, argv is NULL, thus we should avoid calling
> agrv_free(argv), and should jump after it.
>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Good catch!

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
