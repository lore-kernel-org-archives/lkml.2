Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab1KKWrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 17:47:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59867 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab1KKWrr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 17:47:47 -0500
MIME-Version: 1.0
In-Reply-To: <20111111171446.GA13144@emperor.us.dell.com>
References: <1321030375-8221-1-git-send-email-linkinjeon@gmail.com>
	<20111111171446.GA13144@emperor.us.dell.com>
Date: Sat, 12 Nov 2011 07:47:46 +0900
Message-ID: <CAKYAXd_MpvGEqk-WWBV_n0V_DBEco1SnJUpVhWAb3=e+CWhh-Q@mail.gmail.com>
Subject: Re: [PATCH] efi: add option for MSR partition.
From: NamJae Jeon <linkinjeon@gmail.com>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eugeneteo@kernel.sg" <eugeneteo@kernel.sg>,
        "davej@codemonkey.org.uk" <davej@codemonkey.org.uk>,
        "Warns@pre-sense.de" <Warns@pre-sense.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/12 Matt Domsch <Matt_Domsch@dell.com>:
> On Fri, Nov 11, 2011 at 10:52:55AM -0600, Namjae Jeon wrote:
>> After formatting GUID table on MS windows, MSR(Windows Reserved
>> Partition) is not visible on MS windows. But this partition is
>> visible in linux. User don't want to see the stranged partitin. So I
>> try to add option that user can select MSR partition to be visible
>> or not in linux.
>
> Hello Namjae.  Thank you for your patch, however, I do not agree with
> your reasoning.  I understand Windows wishes to hide this partition
> from its users.  That is entirely their choice.  Linux, on the other
> hand, has not hidden this partition from users since it GPT was first
> created over a decade ago.  Your patch changes user-visible
> behavior.  Furthermore, disk partitioning tools such as GNU Parted,
> which parse GPT, will be highly confused when the partition table on
> disk has indices 1..N, but /proc/partitions now reports indices
> 1..(N-1), where the first partition was skipped, and now the whole
> list is "off by one".
>
> As such, I cannot recommend your patch be applied.
Hi Matt.
Thanks for your opinion. I got your point.
>
> Thanks,
> Matt
>
>
> --
> Matt Domsch
> Technology Strategist
> Dell | Office of the CTO
>
