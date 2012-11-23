Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab2KWIZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:25:19 -0500
Received: from nm2-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.127]:37648 "EHLO
	nm2-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754013Ab2KWIZR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:25:17 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 419686.36942.bm@omp1058.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=jK9dIY7vZpK9w0cAo/6NLzrQ4dDcRSIua1sanuBIY1nEAgqrr3ItRFD4nJuGQ9y8FxFrF5+amTaaLF4jhVntaEK9xjIsnYra91tltJcAoVJsgS+dlRU+E8EWFOuJCrA5nZGnTMfg8b7oJWdUA8duZY8KErtmwNQD9MSimQScZsM=;
X-YMail-OSG: Rr32o7gVM1kXrrSbm1jvFimRiFAADVgjCG4t.DiwraH8DNQ
 HWrs9zgWQziYSd_5h_zb_Nm0MwkCaM1A6ziRaxcDv_VKl7uWxpHptNh7x04m
 cA3begDWbEGwWAfYuNv2LHVBn5reAVu._kyxooZf43BUOt8VtZpH0diZYAAr
 zSEUbhSe8a21_Dz.HRiBlnCyhIG_MuIYyfnh35g1Nr2LPegHBh2E9JOU7HfZ
 reB_hH2YPF0LFaoutQXj1GU8EhEFZkMawHU7Kd75EJaJ0SV8zxQNVqMtP9k0
 h0uDv9FruXwgU0D4aQOyNGb485ouBM8XII6a21anqoFUp4fa_uc.JdeiN3i8
 elnbUcqfk1xE0_ChPoSPKLMo_GG9lBKh1mE.1i3QsiZnsQBM6hV7.PPFI6E8
 u57wpMdGXM2m0b2Wm_TJKUXqN3s5csE1zoiTJABljpTX_Icey9EGgvgGVIEQ
 06vPnsS_v6LQDY6s4WaAMWwujSC7Iea6.CHsWAkjHTk50RioVjgxDDqhVXGm
 V6vYkkQt9WahKrNzDGGT5WDJlA8Ukdbi3T6hcfA4yMBEIAIBGCWKH41b.Azj
 FwLEUn2dFW5zGKOiVAIPO8JEoM4ethpC5
X-Rocket-MIMEInfo: 001.001,LS0tLS0gT3JpZ2luYWwgTWVzc2FnZSAtLS0tLQoKRnJvbTogSmFlZ2V1ayBIYW5zZSA8amFlZ2V1ay5oYW5zZUBnbWFpbC5jb20.ClRvOiBtZXRpbiBkIDxtZXRkb3NAeWFob28uY29tPgpDYzogSmFuIEthcmEgPGphY2tAc3VzZS5jej47ICJsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnIiA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47ICJsaW51eC1tbUBrdmFjay5vcmciIDxsaW51eC1tbUBrdmFjay5vcmc.ClNlbnQ6IEZyaWRheSwgTm92ZW1iZXIgMjMsIDIwMTIgMTA6MTcgQU0KU3ViamVjdDoBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.123.460
References: <1353433362.85184.YahooMailNeo@web141101.mail.bf1.yahoo.com> <20121120182500.GH1408@quack.suse.cz> <50AED854.7080300@gmail.com> <1353658123.36385.YahooMailNeo@web141101.mail.bf1.yahoo.com> <50AF3134.3090803@gmail.com>
Message-ID: <1353659115.24777.YahooMailNeo@web141102.mail.bf1.yahoo.com>
Date: Fri, 23 Nov 2012 00:25:15 -0800 (PST)
From: metin d <metdos@yahoo.com>
Reply-To: metin d <metdos@yahoo.com>
Subject: Re: Problem in Page Cache Replacement
To: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
Cc: Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <50AF3134.3090803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----

From: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
To: metin d <metdos@yahoo.com>
Cc: Jan Kara <jack@suse.cz>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "linux-mm@kvack.org" <linux-mm@kvack.org>
Sent: Friday, November 23, 2012 10:17 AM
Subject: Re: Problem in Page Cache Replacement

On 11/23/2012 04:08 PM, metin d wrote:
> ----- Original Message -----
>
> From: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
> To: metin d <metdos@yahoo.com>
> Cc: Jan Kara <jack@suse.cz>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; linux-mm@kvack.org
> Sent: Friday, November 23, 2012 3:58 AM
> Subject: Re: Problem in Page Cache Replacement
>
> On 11/21/2012 02:25 AM, Jan Kara wrote:
>> On Tue 20-11-12 09:42:42, metin d wrote:
>>> I have two PostgreSQL databases named data-1 and data-2 that sit on the
>>> same machine. Both databases keep 40 GB of data, and the total memory
>>> available on the machine is 68GB.
>>>
>>> I started data-1 and data-2, and ran several queries to go over all their
>>> data. Then, I shut down data-1 and kept issuing queries against data-2.
>>> For some reason, the OS still holds on to large parts of data-1's pages
>>> in its page cache, and reserves about 35 GB of RAM to data-2's files. As
>>> a result, my queries on data-2 keep hitting disk.
>>>
>>> I'm checking page cache usage with fincore. When I run a table scan query
>>> against data-2, I see that data-2's pages get evicted and put back into
>>> the cache in a round-robin manner. Nothing happens to data-1's pages,
>>> although they haven't been touched for days.
>> Hi metin d,
>> fincore is a tool or ...? How could I get it?
>> Regards,
>> Jaegeuk
>
> Hi Jaegeuk,
>
> Yes, it is a tool, you get it from here :
> http://code.google.com/p/linux-ftools/


> Hi Metin,

> Could you give me a link to download it? I can't get it from the link 
> you give me. Thanks in advance. :-)

> Regards,
> Jaegeuk

Hi Jaegeuk,

You may need to install mercurial on your system, I'm able to download source code with this command:

hg clone https://code.google.com/p/linux-ftools/


Regards,
Metin

>
>
> Regards,
> Metin
>>> Does anybody know why data-1's pages aren't evicted from the page cache?
>>> I'm open to all kind of suggestions you think it might relate to problem.
>>      Curious. Added linux-mm list to CC to catch more attention. If you run
>> echo 1 >/proc/sys/vm/drop_caches
>>      does it evict data-1 pages from memory?
>>
>>> This is an EC2 m2.4xlarge instance on Amazon with 68 GB of RAM and no
>>> swap space. The kernel version is:
>>>
>>> $ uname -r
>>> 3.2.28-45.62.amzn1.x86_64
>>> Edit:
>>>
>>> and it seems that I use one NUMA instance, if  you think that it can a problem.
>>>
>>> $ numactl --hardware
>>> available: 1 nodes (0)
>>> node 0 cpus: 0 1 2 3 4 5 6 7
>>> node 0 size: 70007 MB
>>> node 0 free: 360 MB
>>> node distances:
>>> node   0
>>>      0:  10
>>                                  Honza
