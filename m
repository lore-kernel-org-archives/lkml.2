Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab2FSKOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:14:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47614 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab2FSKO2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:14:28 -0400
MIME-Version: 1.0
In-Reply-To: <4FDFFEF8.9000609@redhat.com>
References: <1340002390-3950-1-git-send-email-asias@redhat.com>
	<CAJSP0QXOn-5Krm6hSMmm=zRYkG43k9F4Xe6P+ENMFtgMhTupFA@mail.gmail.com>
	<4FDEF73E.3010501@redhat.com>
	<CAJSP0QXj0brxkTRGCMcjYU3AZwFbk+O5D2ATNz8GLECt9rNs7w@mail.gmail.com>
	<4FDFFEF8.9000609@redhat.com>
Date: Tue, 19 Jun 2012 11:14:26 +0100
Message-ID: <CAJSP0QWcRbUPqY5dhEp00p0HKx_vaH-Hbn7gfoaQrjLvPt01=g@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Improve virtio-blk performance
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Asias He <asias@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 5:24 AM, Asias He <asias@redhat.com> wrote:
> On 06/18/2012 06:58 PM, Stefan Hajnoczi wrote:
>>
>> As long as the latency is decreasing that's good.  But It's worth
>> keeping in mind that these percentages are probably wildly different
>> on real storage devices and/or qemu-kvm.  What we don't know here is
>> whether this bottleneck matters in real environments - results with
>> real storage and with qemu-kvm would be interesting.
>
>
> Yes. Here is the performance data on a Fusion-IO SSD device.
>
> Fio test is performed in a 8 vcpu guest with Fusion-IO based guest using kvm
> tool.
>
>    Short version:
>     With bio-based IO path, sequential read/write, random read/write
>     IOPS boost         : 11%, 11%, 13%, 10%
>     Latency improvement: 10%, 10%, 12%, 10%

Nice, I'm glad the improvement shows on real hardware.

Stefan
