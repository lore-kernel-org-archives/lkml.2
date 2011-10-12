Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159Ab1JLOIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:08:17 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50292 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1JLOIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:08:16 -0400
MIME-Version: 1.0
In-Reply-To: <CALxABCaNGyu5Ef+eRVXQ_JPaKUNjQ6OS76Suix4BM3YryrNXNQ@mail.gmail.com>
References: <20111006190526.GA13883@redhat.com>
	<CAOULuOYy3HKbmFa8e9MFDCrduQKZhzgZ2CTskXTWxKCmFNRSRQ@mail.gmail.com>
	<CALxABCaNGyu5Ef+eRVXQ_JPaKUNjQ6OS76Suix4BM3YryrNXNQ@mail.gmail.com>
Date: Wed, 12 Oct 2011 10:08:15 -0400
Message-ID: <CAOULuObVkpOOYoUQ+QYJQK8pNDQf8vZFJRE5gK867sjK=Xk_Rg@mail.gmail.com>
Subject: Re: RFC: virtualbox tainting.
From: Parag Warudkar <parag.lkml@gmail.com>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 3:55 AM, Alex Riesen <raa.lkml@gmail.com> wrote:
> On Wed, Oct 12, 2011 at 02:57, Parag Warudkar <parag.lkml@gmail.com> wrote:
>> Why can't the automatic bug filing tools have a user space list of
>> offending modules that it can use to opt out of automatically filing
>> kernel bugs? ...
>
> Maybe because an oops is not always conveniently accompanied by enough
> information
> to opt-out.
>

In which case the reporting of the OOPS is useless anyways
irrespective of whether or not vboxdrv was loaded. So the tool  can
opt out based on the fact that it cannot find enough info in the OOPS
- missing module list for example. But I don't think that's a very
likely scenario - oops is in most cases accompanied by tainted flag
and module list - the possibility of OOPS printing only tainted but
not module list is not very real and can be ignored.

Parag
