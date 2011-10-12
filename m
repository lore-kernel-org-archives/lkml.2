Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab1JLOSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:18:31 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51576 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1JLOSb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:18:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAOULuObVkpOOYoUQ+QYJQK8pNDQf8vZFJRE5gK867sjK=Xk_Rg@mail.gmail.com>
References: <20111006190526.GA13883@redhat.com> <CAOULuOYy3HKbmFa8e9MFDCrduQKZhzgZ2CTskXTWxKCmFNRSRQ@mail.gmail.com>
 <CALxABCaNGyu5Ef+eRVXQ_JPaKUNjQ6OS76Suix4BM3YryrNXNQ@mail.gmail.com> <CAOULuObVkpOOYoUQ+QYJQK8pNDQf8vZFJRE5gK867sjK=Xk_Rg@mail.gmail.com>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Wed, 12 Oct 2011 16:18:09 +0200
Message-ID: <CALxABCYQP52grqBr_8163baGuMDGPe7uL4f5Xa2-dr6MhsQ_Ow@mail.gmail.com>
Subject: Re: RFC: virtualbox tainting.
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 16:08, Parag Warudkar <parag.lkml@gmail.com> wrote:
> On Wed, Oct 12, 2011 at 3:55 AM, Alex Riesen <raa.lkml@gmail.com> wrote:
>> On Wed, Oct 12, 2011 at 02:57, Parag Warudkar <parag.lkml@gmail.com> wrote:
>>> Why can't the automatic bug filing tools have a user space list of
>>> offending modules that it can use to opt out of automatically filing
>>> kernel bugs? ...
>>
>> Maybe because an oops is not always conveniently accompanied by enough
>> information
>> to opt-out.
>>
>
> In which case the reporting of the OOPS is useless anyways
> irrespective of whether or not vboxdrv was loaded. So the tool  can

Of course not. There is a lot of insight in the instruction dump,
which may be still present, or in stack trace.
