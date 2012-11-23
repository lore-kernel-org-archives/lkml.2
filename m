Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161008Ab2KWIIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:08:46 -0500
Received: from nm6.bullet.mail.bf1.yahoo.com ([98.139.212.165]:47243 "EHLO
	nm6.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030255Ab2KWIIp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:08:45 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 271599.49294.bm@omp1019.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=I/siNWg1Cf6VonRtAVW42HxSJ1gpFKQNa1wnomAPQGGLh9/PM9JsaAhs4+t2kpkNdxf5xNM3icke7eOQ3MPOCm9klsSjR3gglaJD4FAo40ofhlb6BloO5xhqq/UQCk1w9RQNVqFXl9hETXoOwc7KVZFXtQ6KoYtxj+IKW5EeQjA=;
X-YMail-OSG: _KjlndQVM1l2uGZVJGjA2c1n8jh4vnbiUefaXDo4j7icfyO
 82GpIBU4l5U5g70RLf4EBlRvipX6lQb_dUvDvssqffo.3gvmmhoOGjB9ryuC
 wsGpCZCASpmsMyjVAC.XupGFmuV.v6IT3SnLffJKiKGJPN6UogjKS3dRI1aY
 RggTJu6XUtN7suOdVY76KdGnZpmwSZsWj3DjM6UO66eg6ctWtGxMkfx.f1Eh
 UtHiYJwy4fv9WvsxX5BAoR4ZrqaRmdrbDfxpr2aEi.ET9Z_AttdrRQc0Wd.d
 T_mCljQ_yO5sPsZGZXeLhvYZ6MytCxvtJ6IpPRdJ1x1Aqadz8g1F6Uu8P3BA
 yUxF4u5SeA8KR.GItrXsNtIyf.W13jacktq.QKerDOqV3fB88L2pWAsYJOvN
 7nPeRmCtswAEjvMBGnf5PJk.jHRR2TL3g6eRfxO2QZ04S66_gvEy26DJ008z
 pMPp8tLvmlNQMUZlrZ1Ssn8a4KuxHqdyKJjmT.2TwY2XAqPpZ_LxLK69Pw1m
 9exFU4KzdaK69NZzi0PYLejwJlZP9N6Wh4ByTcPa5rflrUKI0Anu9Yi3oJR.
 2xpC1RrWbrXLIV13CRUHoaMLHV1Nvk0km3g--
X-Rocket-MIMEInfo: 001.001,LS0tLS0gT3JpZ2luYWwgTWVzc2FnZSAtLS0tLQoKRnJvbTogSmFlZ2V1ayBIYW5zZSA8amFlZ2V1ay5oYW5zZUBnbWFpbC5jb20.ClRvOiBtZXRpbiBkIDxtZXRkb3NAeWFob28uY29tPgpDYzogSmFuIEthcmEgPGphY2tAc3VzZS5jej47ICJsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnIiA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IGxpbnV4LW1tQGt2YWNrLm9yZwpTZW50OiBGcmlkYXksIE5vdmVtYmVyIDIzLCAyMDEyIDM6NTggQU0KU3ViamVjdDogUmU6IFByb2JsZW0gaW4gUGFnZSBDYWMBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.123.460
References: <1353433362.85184.YahooMailNeo@web141101.mail.bf1.yahoo.com> <20121120182500.GH1408@quack.suse.cz> <50AED854.7080300@gmail.com>
Message-ID: <1353658123.36385.YahooMailNeo@web141101.mail.bf1.yahoo.com>
Date: Fri, 23 Nov 2012 00:08:43 -0800 (PST)
From: metin d <metdos@yahoo.com>
Reply-To: metin d <metdos@yahoo.com>
Subject: Re: Problem in Page Cache Replacement
To: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
Cc: Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <50AED854.7080300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----

From: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
To: metin d <metdos@yahoo.com>
Cc: Jan Kara <jack@suse.cz>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; linux-mm@kvack.org
Sent: Friday, November 23, 2012 3:58 AM
Subject: Re: Problem in Page Cache Replacement

On 11/21/2012 02:25 AM, Jan Kara wrote:
> On Tue 20-11-12 09:42:42, metin d wrote:
>> I have two PostgreSQL databases named data-1 and data-2 that sit on the
>> same machine. Both databases keep 40 GB of data, and the total memory
>> available on the machine is 68GB.
>>
>> I started data-1 and data-2, and ran several queries to go over all their
>> data. Then, I shut down data-1 and kept issuing queries against data-2.
>> For some reason, the OS still holds on to large parts of data-1's pages
>> in its page cache, and reserves about 35 GB of RAM to data-2's files. As
>> a result, my queries on data-2 keep hitting disk.
>>
>> I'm checking page cache usage with fincore. When I run a table scan query
>> against data-2, I see that data-2's pages get evicted and put back into
>> the cache in a round-robin manner. Nothing happens to data-1's pages,
>> although they haven't been touched for days.

> Hi metin d,

> fincore is a tool or ...? How could I get it?

> Regards,
> Jaegeuk


Hi Jaegeuk,

Yes, it is a tool, you get it from here :
http://code.google.com/p/linux-ftools/


Regards,
Metin
>>
>> Does anybody know why data-1's pages aren't evicted from the page cache?
>> I'm open to all kind of suggestions you think it might relate to problem.
>    Curious. Added linux-mm list to CC to catch more attention. If you run
> echo 1 >/proc/sys/vm/drop_caches
>    does it evict data-1 pages from memory?
>
>> This is an EC2 m2.4xlarge instance on Amazon with 68 GB of RAM and no
>> swap space. The kernel version is:
>>
>> $ uname -r
>> 3.2.28-45.62.amzn1.x86_64
>> Edit:
>>
>> and it seems that I use one NUMA instance, if  you think that it can a problem.
>>
>> $ numactl --hardware
>> available: 1 nodes (0)
>> node 0 cpus: 0 1 2 3 4 5 6 7
>> node 0 size: 70007 MB
>> node 0 free: 360 MB
>> node distances:
>> node   0
>>    0:  10
>                                 Honza
