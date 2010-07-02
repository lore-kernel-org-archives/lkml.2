Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab0GBEy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 00:54:27 -0400
Received: from lirone.symas.net ([64.71.152.235]:50144 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab0GBEyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 00:54:25 -0400
Message-ID: <4C2D70F0.7090100@symas.com>
Date: Thu, 01 Jul 2010 21:54:08 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.3a5pre) Gecko/20100607 Firefox 3.6
MIME-Version: 1.0
To: Piotr Gluszenia Slawinski <curious@bwv190.internetdsl.tpnet.pl>
CC: Dave Airlie <airlied@redhat.com>, Timothy Meade <zt.tmzt@gmail.com>,
       linux-arm-msm@vger.kernel.org, Saravana Kannan <skannan@codeaurora.org>,
       LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: Closed source userspace graphics drivers with an open source
  kernel component
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com> <AANLkTimgH-DiQyg0f-an5FS3Wyb2b6He3fxxB1L8Ziol@mail.gmail.com> <1278024678.7738.54.camel@c-dwalke-linux.qualcomm.com> <AANLkTinNrpcBg0TXTS78qaI5kPQKD-IbnLpDStu4_BIg@mail.gmail.com> <1278026975.7738.89.camel@c-dwalke-linux.qualcomm.com> <AANLkTilGdNgWIprJ2XZ2gSv2d-DVybGmb9phcboi4fNL@mail.gmail.com> <1278029284.7738.116.camel@c-dwalke-linux.qualcomm.com> <AANLkTilEKPmHKNDNbNpmUvcYC338YezLkNBc4ShfTFdp@mail.gmail.com> <4C2D3066.9040104@codeaurora.org> <AANLkTilsqmCZwLUNJhvDKkralHQZzlRV3ZxaIGbt9-xB@mail.gmail.com> <AANLkTinvzJrx4AqgWYuMg66Djf-snouLQZE7wI9Bu0Kv@mail.gmail.com> <AANLkTimiNKRabIDCLvRwxVfdwuvt76PbDuTn2RocZLVG@mail.gmail.com> <1278038796.19705.21.camel@clockmaker-el6> <Pine.LNX.4.64.1007020456250.9535@bwv190.internetdsl.tpnet.pl>
In-Reply-To: <Pine.LNX.4.64.1007020456250.9535@bwv190.internetdsl.tpnet.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Piotr Gluszenia Slawinski wrote:
>> There is no point supporting companies that give you a little bit of
>> information in exchange they want the support that being in a mainline
>> kernel gives. Its an unfair exchange of knowledge and time, and if they
>> claim they have to make a profit then its even more unfair.
>
> also, they seem to do it quite wrong way. i.e. much simpler would be to
> just implement regular, open driver , and implement additional crypto
> mechanism in chipset itself, allowing to use simple userspace program
> sending certified keys allowing GPU to operate.
> if key is not available and device/driver not paid/registered, then
> GPU would simply lock itself , similiar to pre-paid designs from
> company whose name should not be spoken aloud.
>
> also certain functionality could be ordered with same chip structure,
> i.e. framebuffer, unaccelerated 2d, accel 2d, 3d, etc.
> with user buying proper 'entry level' pre-paid code set from manufacturer.
>
> this would provide quite same functionality (profit), without impacting
> open-source projects like Xorg with unnessesary complications.

Pardon me for intruding in this discussion, but I'm astonished that you 
actually find what you posted to be acceptable. If I pay for a piece of 
hardware, I have the right to use it. Requiring certified keys before it 
performs the function for which it was purchased is pure nonsense.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
