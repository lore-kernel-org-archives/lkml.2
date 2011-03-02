Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab1CBLdD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:33:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035Ab1CBLdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:33:01 -0500
Message-ID: <4D6E2ABF.5040500@redhat.com>
Date: Wed, 02 Mar 2011 08:32:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Evgeniy Dushistov <dushistov@mail.ru>, linux-fsdevel@vger.kernel.org,
        linux-x25@vger.kernel.org, Max Vozeler <max@vozeler.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        netdev@vger.kernel.org, Nick Bowler <nbowler@elliptictech.com>,
        Nick Piggin <npiggin@gmail.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
Subject: Re: [PATCH 0/7] Final BKL removal, take 2
References: <1299021191-17961-1-git-send-email-arnd@arndb.de> <20110302045923.GA28214@suse.de>
In-Reply-To: <20110302045923.GA28214@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 02-03-2011 01:59, Greg KH escreveu:
> On Wed, Mar 02, 2011 at 12:13:04AM +0100, Arnd Bergmann wrote:
>> This is the set of patches that remain from
>> my previous submission one month ago. I've
>> dropped the ones that have either gone into
>> linux-next or got a sufficient number of
>> Acked-by:s so I put them into my own tree.
>>
>> I've updated the usbip, hpfs, ufs and appletalk
>> patches according to the feedback I got.
>>
>> If possible, I'd like the three networking patches
>> to go through the net-next tree, and the two
>> staging patches through the staging tree. I'll
>> add the other ones to my own series if I hear
>> no objections.
> 
> I'll queue up the staging patches in the staging-next tree in a day or
> so, thanks for digging them up.

Greg,

It is probably better to queue the staging/cx25821 patch via my tree, as this is one
of those staging files that it is handled via media tree. So, if it is ok
for you both, I'll get patch 2/7.

Thanks,
Mauro
