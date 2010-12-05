Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab0LEKVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 05:21:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab0LEKVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 05:21:42 -0500
Message-ID: <4CFB679D.5030900@redhat.com>
Date: Sun, 05 Dec 2010 11:21:17 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101110 Thunderbird/3.1.6
MIME-Version: 1.0
To: Heinz Diehl <htd@fritha.org>
CC: Matt <jackdachef@gmail.com>, Mike Snitzer <snitzer@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, Chris Mason <chris.mason@oracle.com>,
        htejun@gmail.com, linux-ext4@vger.kernel.org,
        Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption?
References: <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com> <20101201165229.GC13415@redhat.com> <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com> <4CF692D1.1010906@redhat.com> <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com> <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com> <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com> <20101204193828.GB13871@redhat.com> <AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com> <20101205100954.GA6564@fritha.org>
In-Reply-To: <20101205100954.GA6564@fritha.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2010 11:09 AM, Heinz Diehl wrote:
> On 05.12.2010, Matt wrote: 

> I have to take back my other two emails, stating that no corruption
> happened with the dm-crypt multi-cpu patch. Today, I encountered
> filesystem corruption on one, and a complete hardlock on another machine.
> No logfile entries, no m-sysrq, a complete deadlock. Filesystem was
> corrupted here too, had to reboot from CD.

Which kernel? 2.6.37-rc?

Anyone seen this with 2.6.36 and the same dmcrypt patch?
(All info I had is that is is stable with here.)

It still seems to like dmcrypt with its parallel processing is just
trigger to another bug in 37-rc.

Milan
