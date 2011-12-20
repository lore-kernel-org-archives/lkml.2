Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1LTKrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:47:41 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37182 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1LTKrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:47:33 -0500
MIME-Version: 1.0
In-Reply-To: <CALfB72CAwzRe3u2+yQ15+coY9kNgFTZ_Be-b-+aMe6QvbZy-HA@mail.gmail.com>
References: <CALfB72BHLmN_vkpz9j7mi4yQWaYfJOojqopJ6d4911vuf3WRAA@mail.gmail.com>
 <CAL1RGDVh7gNTrteiEaGg=4fxW=p3ydZPVf4d1hgtwNT9xUdOMw@mail.gmail.com>
 <CALfB72BUDiZOZY8f4wvYej5Ozur2FZN3h3FNgc78Ur=tUsSCmA@mail.gmail.com>
 <CAL1RGDX9P7tmGTkByEid17FrSFwdAW+4=mb9eUxc_uHvmFOeSg@mail.gmail.com> <CALfB72CAwzRe3u2+yQ15+coY9kNgFTZ_Be-b-+aMe6QvbZy-HA@mail.gmail.com>
From: Albert Strasheim <fullung@gmail.com>
Date: Tue, 20 Dec 2011 12:47:09 +0200
Message-ID: <CALfB72CLZMrS+gTR3=0QcGry4vA3wKmgbhjp9Lc06UZtVcxzZg@mail.gmail.com>
Subject: Re: kernel BUG at drivers/iommu/intel-iommu.c:1767 on F16 3.1.1-2.fc16.x86_64
To: Roland Dreier <roland@purestorage.com>
Cc: linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any news on this one?

Regards

Albert

On Thu, Dec 8, 2011 at 8:31 PM, Albert Strasheim <fullung@gmail.com> wrote:
> On Thu, Dec 8, 2011 at 8:29 PM, Roland Dreier <roland@purestorage.com> wrote:
>> On Thu, Dec 8, 2011 at 9:56 AM, Albert Strasheim <fullung@gmail.com> wrote:
>>> I think the BIOS has VT-d enabled. dmesg says:
>>> PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
>> Yes, you're crashing in the VT-d code.
>> If you don't care about that, you can boot with the kernel parameter
>> "intel_iommu=off"
>> as a workaround, but it would be nice to get to the bottom of this.
>
> I'm happy to test any patches or provide more information.
>
> Regards
>
> Albert
