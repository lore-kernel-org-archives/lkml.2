Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0H2MxG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 08:53:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab0H2MxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 08:53:05 -0400
Message-ID: <4C7A5821.3010007@redhat.com>
Date: Sun, 29 Aug 2010 15:52:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Matteo Croce <matteo@openwrt.org>, Thomas Backlund <tmb@mandriva.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Natale Vinto <ebballon@gmail.com>
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
References: <AANLkTinq81V6afODRS26Nk1vi68_VUMAfs-tu-P8=dBP@mail.gmail.com> <4C780888.9000301@zytor.com> <AANLkTikCssQSvRX1Gfq0V8B91Sp2gtTCJaPJ=_n9VJXZ@mail.gmail.com> <4C7824F2.1050709@mandriva.org> <AANLkTinjHK-oTmt-6cmN16jWWv9ZjW44wA-A3VTLm+A_@mail.gmail.com> <4C784544.2010305@zytor.com>
In-Reply-To: <4C784544.2010305@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/28/2010 02:07 AM, H. Peter Anvin wrote:
> On 08/27/2010 02:32 PM, Matteo Croce wrote:
>> can I ignore the return value when I expect val to be non zero?
>> the doc says: "On error, the variable @x is set to zero."
> No.  You need to deliver a page fault to the application in this case.
>
> The *real* test for this kind of crap is correct page fault behavior,
> and so forth.
>
> Also, at the very least you need to check for:
>
> - CS == USER_CS

Is that mandated by the ABI?  Is it illegal for an application to load a 
segment with a nonzero base into the LDT and use it for CS?

What about vm86?

-- 
error compiling committee.c: too many arguments to function

