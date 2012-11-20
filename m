Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab2KTDBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 22:01:08 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56655 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab2KTDBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 22:01:06 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1211201323170.1407@tundra.namei.org>
References: <20121119233459.GA9524@www.outflux.net>
	<alpine.LRH.2.02.1211201323170.1407@tundra.namei.org>
Date: Mon, 19 Nov 2012 19:01:04 -0800
X-Google-Sender-Auth: NlUWATeFFFCQ_ipu52cIARgxCm8
Message-ID: <CAGXu5jJe0-nu2e+QAGeYGiufumXd7JR-z_JCt+OCHVKhmnvN1Q@mail.gmail.com>
Subject: Re: [PATCH] Yama: remove locking from delete path
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        John Johansen <john.johansen@canonical.com>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 6:23 PM, James Morris <jmorris@namei.org> wrote:
> On Mon, 19 Nov 2012, Kees Cook wrote:
>
>> Instead of locking the list during a delete, mark entries as invalid
>> and trigger a workqueue to clean them up. This lets us easily handle
>> task_free from interrupt context.
>>
>> Cc: Sasha Levin <sasha.levin@oracle.com>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> This doesn't apply cleanly to my -next branch.

Did you already apply this from last week?
https://lkml.org/lkml/2012/11/13/808

> Kees: can you think about using git to push changes to me for Yama?

If this pace of changes keeps up, sure thing.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
