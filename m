Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab1IOHu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 03:50:57 -0400
Received: from mail.ss.pku.edu.cn ([211.101.48.138]:51668 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab1IOHu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 03:50:56 -0400
MIME-Version: 1.0
In-Reply-To: <4E71A821.6010106@gmx.de>
References: <fa.FZDTDqnxL4JfQvyaCQTn405rzwM@ifi.uio.no>
	<ee48c89a-1e72-4b35-b9fc-99f4b8ade483@glegroupsg2000goo.googlegroups.com>
	<CAF1ivSY7rHuA_SGpnPkQ2hLwwOTEtDFTn=e_vx1=C_kW3aDjRA@mail.gmail.com>
	<CAF1ivSZzUiwn+pqLCtOiCEDvjwpLXrXBkCL5OnsAW1vLdMY32w@mail.gmail.com>
	<4E71A821.6010106@gmx.de>
Date: Thu, 15 Sep 2011 15:50:51 +0800
Message-ID: <CAF1ivSZaeW8en+toPBuTBvtMqY6dFwmJW_b_fitzgpuTTL0s=g@mail.gmail.com>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
From: Lin Ming <mlin@ss.pku.edu.cn>
To: Thomas Sattler <tsattler@gmx.de>
Cc: slawomir.czarko@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 3:24 PM, Thomas Sattler <tsattler@gmx.de> wrote:
> Am 15.09.2011 08:48, schrieb Lin Ming:
>>> Hi, Thomas
>>>
>>> Do you still see this problem on latest kernel(2.6.31-rc6)?
>>> I try to run firefox (>50 open Tabs), but can't reproduce
>>> this on 2.6.31-rc6 kernel.
>>
>> Sorry, I mean 3.1-rc6
>
> For me the problem was gone with Mel Gorman's patchset "Fix
> compaction stalls due to accounting errors in isolated page
> accounting". I applied them to 2.6.38.8 and never had any
> problems.
>
> They went into 2.6.39.4 and 3.0 and both machines that were
> affected are now running fine. (One of the machine throws
> MCE-Errors every now and than, but this is another problem.)

Thanks for the info.

Strange that Slawomir still saw the similar problem for 2.6.40(that is
3.0) kernel.
http://marc.info/?l=linux-kernel&m=131600780131502&w=2
