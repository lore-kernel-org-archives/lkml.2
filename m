Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab0GBDFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 23:05:20 -0400
Received: from bwv190.internetdsl.tpnet.pl ([83.18.229.190]:47596 "EHLO
	bwv190.internetdsl.tpnet.pl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692Ab0GBDFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 23:05:18 -0400
Date: Fri, 2 Jul 2010 05:01:58 +0200 (CEST)
From: Piotr Gluszenia Slawinski <curious@bwv190.internetdsl.tpnet.pl>
To: Dave Airlie <airlied@redhat.com>
cc: Timothy Meade <zt.tmzt@gmail.com>, linux-arm-msm@vger.kernel.org,
       Saravana Kannan <skannan@codeaurora.org>,
       LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: Closed source userspace graphics drivers with an open source 
 kernel component
In-Reply-To: <1278038796.19705.21.camel@clockmaker-el6>
Message-ID: <Pine.LNX.4.64.1007020456250.9535@bwv190.internetdsl.tpnet.pl>
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
 <1278038796.19705.21.camel@clockmaker-el6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is no point supporting companies that give you a little bit of
> information in exchange they want the support that being in a mainline
> kernel gives. Its an unfair exchange of knowledge and time, and if they
> claim they have to make a profit then its even more unfair.

also, they seem to do it quite wrong way. i.e. much simpler would be to 
just implement regular, open driver , and implement additional crypto
mechanism in chipset itself, allowing to use simple userspace program
sending certified keys allowing GPU to operate.
if key is not available and device/driver not paid/registered, then
GPU would simply lock itself , similiar to pre-paid designs from
company whose name should not be spoken aloud.

also certain functionality could be ordered with same chip structure,
i.e. framebuffer, unaccelerated 2d, accel 2d, 3d, etc.
with user buying proper 'entry level' pre-paid code set from manufacturer.

this would provide quite same functionality (profit), without impacting
open-source projects like Xorg with unnessesary complications.


-- 

