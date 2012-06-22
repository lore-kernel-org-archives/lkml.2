Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178Ab2FVLvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:51:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56686 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab2FVLvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:51:47 -0400
Message-ID: <4FE45C4E.8060808@gmail.com>
Date: Fri, 22 Jun 2012 13:51:42 +0200
From: Paolo Pisati <p.pisati@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "T Krishnamoorthy, Balaji" <balajitk@ti.com>
CC: Ming Lei <ming.lei@canonical.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Venkatraman S <svenkatr@ti.com>
Subject: Re: MMC: commit dba3c29 ruins mmc card data on beagle-xm revB
References: <CACVXFVO-Wm1Qwporby1M=+yPz81AWHpZRBZSbr5tgT32b6sSEA@mail.gmail.com> <CANrkHUYd8Ww6De4MiZ8_oPfcnhvtsZXOySLRiWSBU4QUQ6beHw@mail.gmail.com> <CACVXFVP16UmHe-GGydrSMgGHwnkSvYhnY339=zr=BfCehvS8Kw@mail.gmail.com> <CANrkHUaxJGcv2bdUWTCB_oKct-iFCKCdb7OQPTUjS4MuKeCS2w@mail.gmail.com> <4FE0AE7B.4040502@gmail.com> <CANrkHUawrQfb+o+W7FrYACv6NocZn_MAym5A209peP8tW1nZRQ@mail.gmail.com>
In-Reply-To: <CANrkHUawrQfb+o+W7FrYACv6NocZn_MAym5A209peP8tW1nZRQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 09:23 AM, T Krishnamoorthy, Balaji wrote:
>>
>> i just want to say that i'm affected by this too, and i can reproduce it
>> 100%.
>>
> 
> Is it with SD or MMC card
> Can you provide Beagle board rev info?

kingston 4g class 4 sdhc c04g taiwan

tested on a beagle xm rev a and rev c, both boards exhibit the same
problem with this card, while with a brand new sandisk 16gb sdhc class 4
card, everything is ok.

i tried reverting dba3c29 "Enable Auto CMD12", and both cards are
behaving fine.

>> do you want me to run that patch or you already have enough data?
> 
> Can you enable MMC debug and apply the debug patch I provided.
> The debug patch did not print any AUTOCMD errors with Ming Lei setup.

http://people.canonical.com/~ppisati/mmc-testing/

test-mmc.sh: script used for testing

test-mmc.log: md5sum of file copied around (as you can see after the
umount the md5 changes)

test-mmc.syslog: mmc-debug output (plus your patch)

after the test, my sd card was so badly wounded that it wouldn't even boot.
-- 
bye,
p.
