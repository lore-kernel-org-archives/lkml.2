Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab0GBGze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 02:55:34 -0400
Received: from bwv190.internetdsl.tpnet.pl ([83.18.229.190]:55336 "EHLO
	bwv190.internetdsl.tpnet.pl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752588Ab0GBGzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 02:55:32 -0400
Date: Fri, 2 Jul 2010 08:52:04 +0200 (CEST)
From: Piotr Gluszenia Slawinski <curious@bwv190.internetdsl.tpnet.pl>
To: Howard Chu <hyc@symas.com>
cc: Dave Airlie <airlied@redhat.com>, Timothy Meade <zt.tmzt@gmail.com>,
       linux-arm-msm@vger.kernel.org, Saravana Kannan <skannan@codeaurora.org>,
       LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: Closed source userspace graphics drivers with an open source 
 kernel component
In-Reply-To: <4C2D70F0.7090100@symas.com>
Message-ID: <Pine.LNX.4.64.1007020837560.9535@bwv190.internetdsl.tpnet.pl>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
 <AANLkTimgH-DiQyg0f-an5FS3Wyb2b6He3fxxB1L8Ziol@mail.gmail.com>
 <1278024678.7738.54.camel@c-dwalke-linux.qualcomm.com>
 <AANLkTinNrpcBg0TXTS78qaI5kPQKD-IbnLpDStu4_BIg@mail.gmail.com>
 <1278026975.7738.89.camel@c-dwalke-linux.qualcomm.com>
 <AANLkTilGdNgWIprJ2XZ2gSv2d-DVybGmb9phcboi4fNL@mail.gmail.com>
 <1278029284.7738.116.camel@c-dwalke-linux.qualcomm.com>
 <AANLkTilEKPmHKNDNbNpmUvcYC338YezLkNBc4ShfTFdp@mail.gmail.com>
 <4C2D3066.9040104@codeaurora.org> <AANLkTilsqmCZwLUNJhvDKkralHQZzlRV3ZxaIGbt9-xB@mail.gmail.com>
 <AANLkTinvzJrx4AqgWYuMg66Djf-snouLQZE7wI9Bu0Kv@mail.gmail.com>
 <AANLkTimiNKRabIDCLvRwxVfdwuvt76PbDuTn2RocZLVG@mail.gmail.com>
 <1278038796.19705.21.camel@clockmaker-el6> <Pine.LNX.4.64.1007020456250.9535@bwv190.internetdsl.tpnet.pl>
 <4C2D70F0.7090100@symas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Piotr Gluszenia Slawinski wrote:
>> >  There is no point supporting companies that give you a little bit of
>> >  information in exchange they want the support that being in a mainline
>> >  kernel gives. Its an unfair exchange of knowledge and time, and if they
>> >  claim they have to make a profit then its even more unfair.
>>
>>  also, they seem to do it quite wrong way. i.e. much simpler would be to
>>  just implement regular, open driver , and implement additional crypto
>>  mechanism in chipset itself, allowing to use simple userspace program
>>  sending certified keys allowing GPU to operate.
>>  if key is not available and device/driver not paid/registered, then
>>  GPU would simply lock itself , similiar to pre-paid designs from
>>  company whose name should not be spoken aloud.
>>
>>  also certain functionality could be ordered with same chip structure,
>>  i.e. framebuffer, unaccelerated 2d, accel 2d, 3d, etc.
>>  with user buying proper 'entry level' pre-paid code set from manufacturer.
>>
>>  this would provide quite same functionality (profit), without impacting
>>  open-source projects like Xorg with unnessesary complications.
>
> Pardon me for intruding in this discussion, but I'm astonished that you 
> actually find what you posted to be acceptable. If I pay for a piece of 
> hardware, I have the right to use it. Requiring certified keys before it 
> performs the function for which it was purchased is pure nonsense.

in this context it is more lease than purhase, similiar to situation
when you buy cellphone, but you are limited by the sim card to access
networks, and sometimes even own adress book (when your account is 
drained, your adress book stored on sim data card is locked).

i do not claim such practices are convient for users, yet they are
very convient for hardware vendors, and it seems more 'open cards' play
which seems more clear to user than situation in which you need binary 
blobs which can contain everything from rootkit to actual crypto routine
(i.e. to prevent driver running on 'non original' clone video cards made
by competitor company) running with ROOT privileges on the computers of 
users being told it is Only Way (tm) to make given company profit and 
survive, while providing some functionality as a trade.

so to resume such solution - one gets fair information about to which 
extent company allows usage of hardware sold to user (without messy 'end 
user license' implied on binary drivers) , and can perform clear
decision - either buying 'secure' and 'genuinely original' video card
with options one needs and is able to pay for (which includes
software development price) , or goes for more 'open' solutions.

mind you most of hardware vendors do NOT want you to purhase
hardware, at best they want LICENSE you to use it for specific
purpose, and specific period. the wish of yours to freely use
hardware does not represent accurate wish of casual users ,
which do not care about freedom as long as hardware allows them
to perform specific task.

either way imho mixing those two attitudes is erroneus,
as it creates confusion and beliefs that some hardware is intended
for free use, and in same time that some software should provide
infrastructure to limit safety and freedom of users.
also it leads to development of BOTH. the sooner those two will
be separated, the sooner alternatives will be created,
and most importantly RECOGNIZED by market.

-- 

