Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab0LAUpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 15:45:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab0LAUpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 15:45:50 -0500
Message-ID: <4CF6B3E8.2000406@redhat.com>
Date: Wed, 01 Dec 2010 21:45:28 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101110 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jon Nelson <jnelson@jamponi.net>
CC: Matt <jackdachef@gmail.com>, Mike Snitzer <snitzer@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, Chris Mason <chris.mason@oracle.com>,
        htejun@gmail.com
Subject: Re: dm-crypt barrier support is effective
References: <20101107194547.GA12521@basil.fritz.box> <4CD71C8B.1050604@redhat.com> <20101107230508.GB17592@basil.fritz.box> <20101108145809.GD29714@redhat.com> <1289238930-sup-9765@think> <20101114205925.GA20451@redhat.com> <AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com> <4CE05A9E.9090204@redhat.com> <AANLkTimT0t3xqgKdAn7MBPD7ED-9uPS+WJE0z+K8tciu@mail.gmail.com> <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com> <20101201165229.GC13415@redhat.com> <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com> <4CF692D1.1010906@redhat.com> <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
In-Reply-To: <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/01/2010 08:34 PM, Jon Nelson wrote:
> Perhaps this is useful: for myself, I found that when I started using
> 2.6.37rc3 that postgresql starting having a *lot* of problems with
> corruption. Specifically, I noted zeroed pages, corruption in headers,
> all sorts of stuff on /newly created/ tables, especially during index
> creation. I had a fairly high hit rate of failure. I backed off to
> 2.6.34.7 and have *zero* problems (in fact, prior to 2.6.37rc3, I had
> never had a corruption issue with postgresql). I ran on 2.6.36 for a
> few weeks as well, without issue.
> 
> I am using kcrypt with lvm on top of that, and ext4 on top of that.

With unpatched dmcrypt (IOW with Linus' git)? Then it must be ext4 or
dm-core problem because there were no patches for dm-crypt...

Anyway, thanks for hint how to reproduce it.

Milan
