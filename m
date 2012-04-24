Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849Ab2DXVli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:41:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35458 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114Ab2DXVlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:41:37 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAHGf_=qg4W0vL2KbkOMzCqH-kGmuaPsCJVoKpRoMO9KFfUT+0g@mail.gmail.com>
References: <20120424200813.GK21224@moon> <CAGXu5jKEaBUrF8RH+tosVZrf-qPetTPaMLNUqq2xKGaV6YrbEw@mail.gmail.com>
 <CAHGf_=qg4W0vL2KbkOMzCqH-kGmuaPsCJVoKpRoMO9KFfUT+0g@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Wed, 25 Apr 2012 09:41:16 +1200
Message-ID: <CAKgNAkhDLFLJbg4g62SXB3aVdf24+d-Z7kGLPiCQKvKXas34Mw@mail.gmail.com>
Subject: Re: [PATCH -mm] c/r: prctl: Return -EFAULT instead of -EINVAL in case
 if underlied VMA is not found
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        MEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 9:38 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> On Tue, Apr 24, 2012 at 4:27 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Tue, Apr 24, 2012 at 1:08 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>>> In case if underlied VMA is not found prctl_set_mm will return -EINVAL,
>>> but Michael proposed to return -EFAULT and Kosaki seconded.
>>> Make it so.
>>>
>>> Reported-by: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
>>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>>
>> Acked-by: Kees Cook <keescook@chromium.org>
>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
