Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab1KQR2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 12:28:40 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63172 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab1KQR2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 12:28:39 -0500
MIME-Version: 1.0
In-Reply-To: <4EC4F348.6020101@parallels.com>
References: <4EC4F2FB.408@parallels.com> <4EC4F348.6020101@parallels.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Nov 2011 15:28:17 -0200
X-Google-Sender-Auth: mGhPi_Sovz4028mL1YmfoRtoOcg
Message-ID: <CA+55aFwep=g-ZSEgeJoO1dANjTYSb71jD_PR_7urb5=DrrJ8Sw@mail.gmail.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given pids
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
        Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. Patches 1-2 look sane on their own. I think we can merge them
regardless in the next cycle if Oleg & co agree. Oleg?

Patch 3 obviously is generating discussion and actually introduces new
functionality, so this one is the contentious one..

                  Linus

On Thu, Nov 17, 2011 at 9:43 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
>
> When restoring a task (or a set of tasks) we need to recreate them
> with exactly the same pid(s) as they had before.  [...]
