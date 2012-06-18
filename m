Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab2FRK65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:58:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47587 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265Ab2FRK64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:58:56 -0400
MIME-Version: 1.0
In-Reply-To: <4FDEF73E.3010501@redhat.com>
References: <1340002390-3950-1-git-send-email-asias@redhat.com>
	<CAJSP0QXOn-5Krm6hSMmm=zRYkG43k9F4Xe6P+ENMFtgMhTupFA@mail.gmail.com>
	<4FDEF73E.3010501@redhat.com>
Date: Mon, 18 Jun 2012 11:58:54 +0100
Message-ID: <CAJSP0QXj0brxkTRGCMcjYU3AZwFbk+O5D2ATNz8GLECt9rNs7w@mail.gmail.com>
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

On Mon, Jun 18, 2012 at 10:39 AM, Asias He <asias@redhat.com> wrote:
> On 06/18/2012 05:14 PM, Stefan Hajnoczi wrote:
>>
>> On Mon, Jun 18, 2012 at 7:53 AM, Asias He <asias@redhat.com> wrote:
>>>
>>> Fio test shows it gives, 28%, 24%, 21%, 16% IOPS boost and 32%, 17%, 21%,
>>> 16%
>>> latency improvement for sequential read/write, random read/write
>>> respectively.
>>
>>
>> Sounds great.  What storage configuration did you use (single spinning
>> disk, SSD, storage array) and are these numbers for parallel I/O or
>> sequential I/O?
>
>
> I used ramdisk as the backend storage.

As long as the latency is decreasing that's good.  But It's worth
keeping in mind that these percentages are probably wildly different
on real storage devices and/or qemu-kvm.  What we don't know here is
whether this bottleneck matters in real environments - results with
real storage and with qemu-kvm would be interesting.

Stefan
