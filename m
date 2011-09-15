Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934925Ab1IOU4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:56:07 -0400
Received: from mail-vw0-f42.google.com ([209.85.212.42]:52598 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934775Ab1IOU4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:56:05 -0400
MIME-Version: 1.0
In-Reply-To: <4E726489.6080606@linux.intel.com>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
	<1316117394-21666-8-git-send-email-andi@firstfloor.org>
	<CA+5PVA66idjR6uLaJOJm81ZJrjRiYQVJMvKNttAS7B=4iUoqVQ@mail.gmail.com>
	<4E726489.6080606@linux.intel.com>
Date: Thu, 15 Sep 2011 16:56:04 -0400
Message-ID: <CA+5PVA52Q+9jBbF7fdjDgpkv9rAwPKgyH+34zMPxYXusn-LctQ@mail.gmail.com>
Subject: Re: [PATCH 07/27] Initconst section fixes for POWERPC
From: Josh Boyer <jwboyer@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 4:48 PM, Andi Kleen <ak@linux.intel.com> wrote:
> On 9/15/2011 1:45 PM, Josh Boyer wrote:
>>
>> On Thu, Sep 15, 2011 at 4:09 PM, Andi Kleen<andi@firstfloor.org>  wrote:
>>>
>>> From: Andi Kleen<ak@linux.intel.com>
>>>
>> What's the problem again?
>
> It's wrong. For more details see 0/*

Do you have an example of the compiler/linker erroring out?

>
>>      "amcc,kilauea",
>> There's an almost identical section in
>> arch/powerpc/platforms/44x/ppc44x_simple.c.  Does that need whatever
>> this is fixing as well?
>
> That one is not const.

It should be.  Which is not your problem but I guess if I figure out
how to have the problem I'll fix it myself.

josh
