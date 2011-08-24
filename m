Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab1HXFbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 01:31:42 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:36751 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1HXFbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 01:31:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLHzFnP0GuUWyg4U91_AkrK8q5=k1ZhN3JikUxqLQNK5tQ@mail.gmail.com>
References: <1314137806-5747-1-git-send-email-agraf@suse.de>
	<CAOJsxLHzFnP0GuUWyg4U91_AkrK8q5=k1ZhN3JikUxqLQNK5tQ@mail.gmail.com>
Date: Wed, 24 Aug 2011 13:31:39 +0800
Message-ID: <CAM_iQpWD_uYT18XUGg=1FZDsvZx2kSSUEW+EtSYxgg5+gfHR7Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around Qemu to test kernels
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Alexander Graf <agraf@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 1:19 PM, Pekka Enberg <penberg@kernel.org> wrote:
>
> It's nice to see such an honest attempt at improving QEMU usability, Alexander!
>
> One comment: in my experience, having shell scripts under
> Documentation reduces the likelihood that people actually discover
> them so you might want to consider putting it under scripts or tools.
>

I was going to give the same suggestion, +1 for tools/ directory.

Thanks!
