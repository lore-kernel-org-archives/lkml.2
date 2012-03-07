Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab2CGVBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:01:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:38782 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab2CGVBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:01:54 -0500
Message-ID: <4F57CCB9.9090001@linutronix.de>
Date: Wed, 07 Mar 2012 22:01:45 +0100
From: Richard Weinberger <rw@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tim.bird@am.sony.com
Subject: Re: [RFC][PATCH 0/7] UBI checkpointing support
References: <1329250006-22944-1-git-send-email-rw@linutronix.de> <1331136246.32316.39.camel@sauron.fi.intel.com>
In-Reply-To: <1331136246.32316.39.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.03.2012 17:04, schrieb Artem Bityutskiy:
> Another not-so-technical comment.
>
> On Tue, 2012-02-14 at 21:06 +0100, Richard Weinberger wrote:
>> The following patch set implements checkpointing support for
>> UBI. Checkpointing is an optional feature which stores the physical to
>> logical eraseblock relations in a checkpointing superblock to reduce
>> the initialization time of UBI.
>
> So this is basically about improving scalability and "mount" time. This
> has nothing to do with checkpointing most people are aware of.
> Confusing...

Mostly because "checkpointing" is a buzzword. ;-)

> Really, this tirm is already reserved by file-systems, things like
> virtual machines where it means "freezing" the contents and doing COW
> when changing the freezed blocks and guaranteeing the ability to
> "roll-back" to the checkpointed data.
>
> Please, consider an option of picking a different name. In JFFS2 a
> "similar" thing was called "summaries", and even this is better than
> "checkpoint", I think.

What about "Erase block indexing"?
Basically a checkpoint is an index...

Thanks,
//richard

P.s: I'm really bad in picking names.
