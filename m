Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab2EOSK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 14:10:27 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab2EOSKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 14:10:23 -0400
Message-ID: <4FB29BF9.7050200@nod.at>
Date: Tue, 15 May 2012 20:10:01 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Subodh Nijsure <snijsure@grid-net.com>
CC: linux-mtd@lists.infradead.org, Heinz.Egger@linutronix.de,
        tglx@linutronix.de, tim.bird@am.sony.com, linux-kernel@vger.kernel.org,
        dedekind1@gmail.com
Subject: Re: [RFC v4] UBI: Fastmap support (aka checkpointing)
References: <1337101871-31181-1-git-send-email-richard@nod.at> <4FB296EA.5090104@grid-net.com>
In-Reply-To: <4FB296EA.5090104@grid-net.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Subodh,

Am 15.05.2012 19:48, schrieb Subodh Nijsure:
> Hello Richard,
>
> On 05/15/2012 10:11 AM, Richard Weinberger wrote:
>> v1: https://lwn.net/Articles/481612/
>> v2: https://lwn.net/Articles/496586/
>> v3: Didn't release it to linux-mtd
> Will kernel that has older UBI drivers be able to mount and update the
> UBI volumes that have been created with checkpointing feature?

Of course!

> Say I have bootrom that has 3.0.X kernel that has no knowledge of UBI
> checkpointing, and my flash /dev/mtd2 has UBI volume with checkpointing
> enabled. Will this bootrom be able to attach /dev/mtd2 and mount UBI
> volume and read/write files on it?

Sure!
Your bootrom will scan the UBI volume and detect two unknown internal
volumes with compat=delete in their volume headers.
So, it will delete the two fastmap volumes and continue scanning.
It can alter the volume and so on.

Thanks,
//richard

