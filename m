Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab1LHSaN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 13:30:13 -0500
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:52830 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752595Ab1LHSaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 13:30:10 -0500
MIME-Version: 1.0
In-Reply-To: <CALfB72BUDiZOZY8f4wvYej5Ozur2FZN3h3FNgc78Ur=tUsSCmA@mail.gmail.com>
References: <CALfB72BHLmN_vkpz9j7mi4yQWaYfJOojqopJ6d4911vuf3WRAA@mail.gmail.com>
 <CAL1RGDVh7gNTrteiEaGg=4fxW=p3ydZPVf4d1hgtwNT9xUdOMw@mail.gmail.com> <CALfB72BUDiZOZY8f4wvYej5Ozur2FZN3h3FNgc78Ur=tUsSCmA@mail.gmail.com>
From: Roland Dreier <roland@purestorage.com>
Date: Thu, 8 Dec 2011 10:29:47 -0800
Message-ID: <CAL1RGDX9P7tmGTkByEid17FrSFwdAW+4=mb9eUxc_uHvmFOeSg@mail.gmail.com>
Subject: Re: kernel BUG at drivers/iommu/intel-iommu.c:1767 on F16 3.1.1-2.fc16.x86_64
To: Albert Strasheim <fullung@gmail.com>
Cc: linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 8, 2011 at 9:56 AM, Albert Strasheim <fullung@gmail.com> wrote:
> I think the BIOS has VT-d enabled. dmesg says:
>
> PCI-DMA: Intel(R) Virtualization Technology for Directed I/O

Yes, you're crashing in the VT-d code.

If you don't care about that, you can boot with the kernel parameter
"intel_iommu=off"
as a workaround, but it would be nice to get to the bottom of this.

 - R.
