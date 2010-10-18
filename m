Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab0JRLWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 07:22:52 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:56001 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab0JRLWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 07:22:51 -0400
/m: 
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 18 Oct 2010 13:22:41 +0200
From: Richard Weinberger <richard@nod.at>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        <user-mode-linux-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Fwd: Re: UML kernel crash of v2.6.36-rcX kernel
In-Reply-To: <201010181314.27780.toralf.foerster@gmx.de>
References: <201010131328.06465.toralf.foerster@gmx.de>
 <201010181105.17077.toralf.foerster@gmx.de>
 <AANLkTi=UyWg6PUrE_jEs0oqZ_tVw1mMQsoUrDnnqtcHa@mail.gmail.com>
 <201010181314.27780.toralf.foerster@gmx.de>
Message-ID: <64b54ba40b0fdec8e5437061e86457b4@radon2.swed.at>
User-Agent: RoundCube Webmail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 13:14:26 +0200, Toralf Förster
<toralf.foerster@gmx.de> wrote:
> richard -rw- weinberger wrote at 11:31:31
>> Does this help?
>>
>> --- linux-2.6.36-rc8/fs/hostfs/hostfs_user.c.orig       2010-10-18
>> 11:24:33.844592000 +0200
>> +++ linux-2.6.36-rc8/fs/hostfs/hostfs_user.c    2010-10-18
>> 11:24:44.594679000 +0200
>> @@ -388,6 +388,6 @@
>>         spare_out[1] = buf.f_spare[1];
>>         spare_out[2] = buf.f_spare[2];
>>         spare_out[3] = buf.f_spare[3];
>> -       spare_out[4] = buf.f_spare[4];
>> +
>>         return 0;
>>  }
> 
> yes - definitely (BTW I like a preceeding "diff --git" line to make
> the patch
> utility happy ;) )

Good to know. I'll submit a patch (with git ;)).

Thanks,
//richard
