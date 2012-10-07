Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab2JGVoK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 17:44:10 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:10388 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661Ab2JGVoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 17:44:08 -0400
X-IronPort-AV: E=Sophos;i="4.80,548,1344204000"; 
   d="scan'208";a="176170736"
Date: Sun, 7 Oct 2012 23:43:58 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Joe Perches <joe@perches.com>
cc: Julia Lawall <julia.lawall@lip6.fr>, walter harms <wharms@bfs.de>,
        Antti Palosaari <crope@iki.fi>, kernel-janitors@vger.kernel.org,
        rmallon@gmail.com, shubhrajyoti@ti.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] drivers/media/tuners/e4000.c: use macros for
 i2c_msg initialization
In-Reply-To: <1349645970.15802.12.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1210072342460.2745@localhost6.localdomain6>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>  <1349624323-15584-3-git-send-email-Julia.Lawall@lip6.fr>  <5071AEF3.6080108@bfs.de>  <alpine.DEB.2.02.1210071839040.2745@localhost6.localdomain6>  <5071B834.1010200@bfs.de> 
 <alpine.DEB.2.02.1210071917040.2745@localhost6.localdomain6>  <1349633780.15802.8.camel@joe-AO722>  <alpine.DEB.2.02.1210072053550.2745@localhost6.localdomain6> <1349645970.15802.12.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2012, Joe Perches wrote:

> On Sun, 2012-10-07 at 20:56 +0200, Julia Lawall wrote:
>>>> Some people thought that it would be nice to have the macros rather than
>>>> the inlined field initializations, especially since there is no flag for
>>>> write.  A separate question is whether an array of one element is useful,
>>>> or whether one should systematically use & on a simple variable of the
>>>> structure type.  I'm open to suggestions about either point.
>>>
>>> I think the macro naming is not great.
>>>
>>> Maybe add DEFINE_/DECLARE_/_INIT or something other than an action
>>> name type to the macro names.
>>
>> DEFINE and DECLARE usually have a declared variable as an argument, which
>> is not the case here.
>>
>> These macros are like the macros PCI_DEVICE and PCI_DEVICE_CLASS.
>
> I understand that.
>
>> Are READ and WRITE the action names?  They are really the important
>> information in this case.
>
> Yes, most (all?) uses of _READ and _WRITE macros actually
> perform some I/O.

I2C_MSG_READ_DATA?
I2C_MSG_READ_INFO?
I2C_MSG_READ_INIT?
I2C_MSG_PREPARE_READ?

julia
