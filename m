Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab2DXVik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:38:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40076 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab2DXVij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:38:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKEaBUrF8RH+tosVZrf-qPetTPaMLNUqq2xKGaV6YrbEw@mail.gmail.com>
References: <20120424200813.GK21224@moon> <CAGXu5jKEaBUrF8RH+tosVZrf-qPetTPaMLNUqq2xKGaV6YrbEw@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 24 Apr 2012 17:38:17 -0400
Message-ID: <CAHGf_=qg4W0vL2KbkOMzCqH-kGmuaPsCJVoKpRoMO9KFfUT+0g@mail.gmail.com>
Subject: Re: [PATCH -mm] c/r: prctl: Return -EFAULT instead of -EINVAL in case
 if underlied VMA is not found
To: Kees Cook <keescook@chromium.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        MEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 4:27 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Apr 24, 2012 at 1:08 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>> In case if underlied VMA is not found prctl_set_mm will return -EINVAL,
>> but Michael proposed to return -EFAULT and Kosaki seconded.
>> Make it so.
>>
>> Reported-by: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>
> Acked-by: Kees Cook <keescook@chromium.org>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
