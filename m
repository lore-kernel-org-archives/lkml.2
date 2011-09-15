Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935295Ab1IOXE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:04:29 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43272 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935256Ab1IOXE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:04:28 -0400
MIME-Version: 1.0
In-Reply-To: <20110915205709.GB7761@one.firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
	<1316117394-21666-8-git-send-email-andi@firstfloor.org>
	<CA+5PVA66idjR6uLaJOJm81ZJrjRiYQVJMvKNttAS7B=4iUoqVQ@mail.gmail.com>
	<4E726489.6080606@linux.intel.com>
	<CA+5PVA52Q+9jBbF7fdjDgpkv9rAwPKgyH+34zMPxYXusn-LctQ@mail.gmail.com>
	<20110915205709.GB7761@one.firstfloor.org>
Date: Thu, 15 Sep 2011 19:04:28 -0400
Message-ID: <CA+5PVA416wv7fLxyKCe3w+LAmqhJa3d14TeqXxwM_oAbixci5w@mail.gmail.com>
Subject: Re: [PATCH 07/27] Initconst section fixes for POWERPC
From: Josh Boyer <jwboyer@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 4:57 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Thu, Sep 15, 2011 at 04:56:04PM -0400, Josh Boyer wrote:
>> On Thu, Sep 15, 2011 at 4:48 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> > On 9/15/2011 1:45 PM, Josh Boyer wrote:
>> >>
>> >> On Thu, Sep 15, 2011 at 4:09 PM, Andi Kleen<andi@firstfloor.org>  wrote:
>> >>>
>> >>> From: Andi Kleen<ak@linux.intel.com>
>> >>>
>> >> What's the problem again?
>> >
>> > It's wrong. For more details see 0/*
>>
>> Do you have an example of the compiler/linker erroring out?
>
> You currently need a special toolkit set up for this, it doesn't
> happen in normal builds. It's still wrong however.

I'm not arguing against the patch.  I just want to poke around with
what you're reporting.  Where can one get the toolkit?

josh
