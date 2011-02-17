Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab1BQBhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:37:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41497 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab1BQBhb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:37:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Gq/Wsp4/sxbXlO9d6cS861OXXumZK8wPNx+Vnu1JO4ZNoGoRqaNocJqhngqhWKXZyN
         lq5hCEemO9cYm8m7O/P/gpwcby10CMQGkLI3O8nq4ymGnjIW00NpsHqrqdb1+hOC34e7
         k1/UzkJaqsTldlMC9gbARGef2dYOIz+DnscRA=
MIME-Version: 1.0
In-Reply-To: <4D5A90D0.9040403@free.fr>
References: <4D5A90D0.9040403@free.fr>
Date: Thu, 17 Feb 2011 09:37:30 +0800
Message-ID: <AANLkTimvue3JbYZUMrt0KppE1f_MNSsyyb+Upbputs=5@mail.gmail.com>
Subject: Re: WARNING: at kernel/lockdep.c:2323 trace_hardirqs_on_caller+0xb9/0x16c()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 10:42 PM, Daniel Lezcano <daniel.lezcano@free.fr> wrote:
> Hi All,
>
> I am running a 2.6.38-rc4-next-20110215+ kernel on qemu x86_64 and the
> following traces appear in the console:
>
> Feb 15 15:00:24 lucid kernel: ------------[ cut here ]------------
> Feb 15 15:00:24 lucid kernel: WARNING: at kernel/lockdep.c:2323
> trace_hardirqs_on_caller+0xb9/0x16c()
> Feb 15 15:00:24 lucid kernel: Hardware name: Bochs
> Feb 15 15:00:24 lucid kernel: Pid: 1477, comm: mountall Not tainted
> 2.6.38-rc4-next-20110215+ #74
> Feb 15 15:00:24 lucid kernel: Call Trace:
> Feb 15 15:00:24 lucid kernel: <IRQ>  [<ffffffff8102b8a5>] ?
> warn_slowpath_common+0x7b/0x93
> Feb 15 15:00:24 lucid kernel: [<ffffffff8146c097>] ?
> _raw_spin_unlock_irq+0x2b/0x30
> Feb 15 15:00:24 lucid kernel: [<ffffffff8102b8d2>] ?
> warn_slowpath_null+0x15/0x17
> Feb 15 15:00:24 lucid kernel: [<ffffffff8104f796>] ?
> trace_hardirqs_on_caller+0xb9/0x16c
> Feb 15 15:00:24 lucid kernel: [<ffffffff8104f856>] ?
> trace_hardirqs_on+0xd/0xf
> Feb 15 15:00:24 lucid kernel: [<ffffffff8146c097>] ?
> _raw_spin_unlock_irq+0x2b/0x30
> Feb 15 15:00:24 lucid kernel: [<ffffffff812e167e>] ?
> do_ide_request+0x32/0x590

Seems related to IDE SUBSYSTEM

Cc'ing Dave and linux-ide@vger.kernel.org

Thanks,
Yong


-- 
Only stand for myself
