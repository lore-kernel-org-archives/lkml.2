Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1G3QIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 12:08:55 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38824 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1G3QIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 12:08:48 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUW6vv4AX1ao80gT20LjvRPip5vDtqiq_i00qKowB6mjkg@mail.gmail.com>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
	<CA+icZUW6vv4AX1ao80gT20LjvRPip5vDtqiq_i00qKowB6mjkg@mail.gmail.com>
Date: Sat, 30 Jul 2011 12:08:46 -0400
Message-ID: <CACqU3MW1gufdngK6cHyT1mPMUWc94U2DAHN0_pPnxPm6rtN2Eg@mail.gmail.com>
Subject: Re: linux-next: Tree for July 29
From: Arnaud Lacombe <lacombar@gmail.com>
To: sedat.dilek@gmail.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 30, 2011 at 7:38 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Fri, Jul 29, 2011 at 9:38 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> Just in case anyone needs reminding:  Please do not add anything destined
>> for v3.2 into linux-next included trees until after v3.1-rc1.
>>
>> The powerpc allyesconfig and sparc defconfig build (at least) fail today.
>>
>> Changes since 20110728:
>>
>> New tree: moduleh
>>
>
> See all those followup/fixup patches the last day, might be not such a
> good idea to include this tree :-).
In the opposite, that is all the point of including a tree in -next:
give expose to code :)

 - Arnaud

> I wait for next Monday's linux-next.
>
> - Sedat -
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
