Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0ISRI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 13:08:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab0ISRI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 13:08:28 -0400
Message-ID: <4C964382.9000602@redhat.com>
Date: Sun, 19 Sep 2010 19:08:18 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Cam Macdonell <cam@cs.ualberta.ca>
CC: Chris Wright <chrisw@redhat.com>,
        "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Qemu-devel] Re: ACPI error when mapping a 2GB BAR w/ 4GB of
 RAM
References: <AANLkTinORYZOYk9xsST+J=zxgeZPr2BNw3S=dvPPTcdn@mail.gmail.com>	<20100917200428.GD19949@x200.localdomain>	<AANLkTiny67-sKAwn3ipHBDEMx9NJujznNOjAeyZZXj_j@mail.gmail.com>	<AANLkTim0dCDGeC+sLFLSH1Ezb=2UHP6dn=EPBhxBQ4-P@mail.gmail.com>	<20100917211508.GF19949@x200.localdomain> <AANLkTikr7of6M142qTDkUx=2z-SUHWqOZd6hnC+BnEG4@mail.gmail.com>
In-Reply-To: <AANLkTikr7of6M142qTDkUx=2z-SUHWqOZd6hnC+BnEG4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/17/2010 11:45 PM, Cam Macdonell wrote:
> >  It seems most likely...<  2GB also means<= 1GB (which would fit in
> >  the hole).  Although, I have to admit, I'm not sure how seabios handles
> >  the hole nowadays.
> >
> >  What about 2GB with 32bit BAR?
>
> The bios seems to ignore it and the guest can't map it as it cannot
> find an alignment for it.  Seems strange since with 1GB of RAM and 2GB
> BAR, everything should map below 4GB.
>

There are only two possible locations, 0-2GB and 2-4GB.  The first 
clashes with RAM, the second clashes with the bios and fixed-function 
devices.

-- 
error compiling committee.c: too many arguments to function

