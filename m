Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab1HYDo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 23:44:56 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61875 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1HYDoy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 23:44:54 -0400
MIME-Version: 1.0
In-Reply-To: <282DEC42-93F6-411E-97C5-C49D258718C2@suse.de>
References: <1314137806-5747-1-git-send-email-agraf@suse.de>
	<CAOJsxLHzFnP0GuUWyg4U91_AkrK8q5=k1ZhN3JikUxqLQNK5tQ@mail.gmail.com>
	<CAM_iQpWD_uYT18XUGg=1FZDsvZx2kSSUEW+EtSYxgg5+gfHR7Q@mail.gmail.com>
	<282DEC42-93F6-411E-97C5-C49D258718C2@suse.de>
Date: Thu, 25 Aug 2011 11:44:53 +0800
Message-ID: <CAM_iQpVA--TR39AnrjQ6j14W7wYOLr62B52uVj5_RGAUMex8Sg@mail.gmail.com>
Subject: Re: [PATCH] KVM: Add wrapper script around Qemu to test kernels
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Alexander Graf <agraf@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 4:35 AM, Alexander Graf <agraf@suse.de> wrote:
>
> On 24.08.2011, at 00:31, Américo Wang wrote:
>
>> On Wed, Aug 24, 2011 at 1:19 PM, Pekka Enberg <penberg@kernel.org> wrote:
>>>
>>> It's nice to see such an honest attempt at improving QEMU usability, Alexander!
>>>
>>> One comment: in my experience, having shell scripts under
>>> Documentation reduces the likelihood that people actually discover
>>> them so you might want to consider putting it under scripts or tools.
>>>
>>
>> I was going to give the same suggestion, +1 for tools/ directory.
>
> Well, scripts/ is a flat directory where I can just throw in the script. Tools however is split by tool and creating a full new directory for only a single script sounds a bit like overkill to me. I'll move it to scripts/ for now :)

How about the directory tools/testing/ ?

scripts/ is mainly for the tools/utilities we use to build kernel or
do kernel dev,
it is not so suitable for your script IMHO.

Thanks.
