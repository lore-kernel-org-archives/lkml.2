Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab1IWOR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 10:17:59 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:52951 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab1IWOR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 10:17:57 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Sep 2011 10:17:56 EDT
Message-ID: <4E7C9393.7030804@itanic.dy.fi>
Date: Fri, 23 Sep 2011 17:11:31 +0300
From: Timo Kokkonen <kaapeli@itanic.dy.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110822 Thunderbird/6.0
MIME-Version: 1.0
To: Praveen G K <praveen.gk@gmail.com>
CC: Qiang LIU <godliuqiang@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: eMMC low write speed
References: <CAHzg1A-RCpZz-6YzON4cNzrSVpvEP=BCQx0AzZe1negcu2zo6g@mail.gmail.com> <CABg=csR-JzS0s2h=B9yJDJBsaAJZTR7b5iH-cU1EjQyxAQjd1g@mail.gmail.com> <CAHzg1A950qwmUts4nqKn80izXbxhmzoevg5n3g2C4BbwagmA2g@mail.gmail.com>
In-Reply-To: <CAHzg1A950qwmUts4nqKn80izXbxhmzoevg5n3g2C4BbwagmA2g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/11 06:03, Praveen G K wrote:
> Hi Qiang,
> 
> 
> On Thu, Sep 22, 2011 at 7:16 PM, Qiang LIU <godliuqiang@gmail.com> wrote:
>> Hi,
>>
>> I suggest you change another eMMC card or try SDHC card. It seems like
>> a card issue.
> 
> Thanks for the response.  So, do you think this has nothing to do with
> the caching or any such issues, since it is only every 63rd and 64th
> transfer causing this issue?

It is very much possible that the card itself does something internally
on every 63rd or 64th transfer. Such as wear leveling management on the
nand or perhaps some copy-on-write operations if the transfers are not
taking place in contiguous blocks.

As suggested above, you could try with another eMMC or SDCH card if it
makes a different (if possible).

-Timo
