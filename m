Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1IWJcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 05:32:01 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60287 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab1IWJcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 05:32:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAKgNAkj8STLfO2t5gejct+yPFkFtFtojVkYKJREiE7S2QHSctg@mail.gmail.com>
References: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com>
 <20110721165137.GA21345@redhat.com> <CAKgNAkj8STLfO2t5gejct+yPFkFtFtojVkYKJREiE7S2QHSctg@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 23 Sep 2011 11:31:39 +0200
Message-ID: <CAK1hOcNV+Gn2VsMk5zF40J3dw8kkgqQkpphOowa_KiHFd=uR-w@mail.gmail.com>
Subject: Re: [PATCH] man ptrace: add extended description of various ptrace quirks
To: mtk.manpages@gmail.com
Cc: Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Michael Kerrisk <mtk.manpages@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 7:10 AM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
>>> +Tracer can not assume that tracee ALWAYS ends its life by reporting
>>> +WIFEXITED(status) or WIFSIGNALED(status).
>>> +.LP
>>> +.\" or can it? Do we include such a promise into ptrace API?
>>
>> IIRC, we already discussed this... The traced group leader can
>> disappear during mt-exec, otherwise the tracee can never go away
>> silently.

>From userspace perspective, traced group leader doesn't go away
silently, it's execing thread who goes away silently.

> Does your patch need any revision in the light of Oleg's comments?

No, it does not. Please commit it to manpage git.

-- 
vda
