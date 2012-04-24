Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab2DXU1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 16:27:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51976 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab2DXU1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 16:27:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120424200813.GK21224@moon>
References: <20120424200813.GK21224@moon>
Date: Tue, 24 Apr 2012 13:27:19 -0700
X-Google-Sender-Auth: w4Vhlp7YR4S6PlbzTzIXaSXAvmY
Message-ID: <CAGXu5jKEaBUrF8RH+tosVZrf-qPetTPaMLNUqq2xKGaV6YrbEw@mail.gmail.com>
Subject: Re: [PATCH -mm] c/r: prctl: Return -EFAULT instead of -EINVAL in case
 if underlied VMA is not found
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        MEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 1:08 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> In case if underlied VMA is not found prctl_set_mm will return -EINVAL,
> but Michael proposed to return -EFAULT and Kosaki seconded.
> Make it so.
>
> Reported-by: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Chrome OS Security
