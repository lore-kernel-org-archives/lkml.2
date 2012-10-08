Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441Ab2JHFEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 01:04:25 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:40406 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799Ab2JHFEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 01:04:24 -0400
X-IronPort-AV: E=Sophos;i="4.80,549,1344204000"; 
   d="scan'208";a="176191177"
Date: Mon, 8 Oct 2012 07:04:21 +0200 (CEST)
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
In-Reply-To: <1349646718.15802.16.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1210080702450.1972@localhost6.localdomain6>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>  <1349624323-15584-3-git-send-email-Julia.Lawall@lip6.fr>  <5071AEF3.6080108@bfs.de>  <alpine.DEB.2.02.1210071839040.2745@localhost6.localdomain6>  <5071B834.1010200@bfs.de> 
 <alpine.DEB.2.02.1210071917040.2745@localhost6.localdomain6>  <1349633780.15802.8.camel@joe-AO722>  <alpine.DEB.2.02.1210072053550.2745@localhost6.localdomain6>  <1349645970.15802.12.camel@joe-AO722>  <alpine.DEB.2.02.1210072342460.2745@localhost6.localdomain6>
 <1349646718.15802.16.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2012, Joe Perches wrote:

> On Sun, 2012-10-07 at 23:43 +0200, Julia Lawall wrote:
>> On Sun, 7 Oct 2012, Joe Perches wrote:
>>>> Are READ and WRITE the action names?  They are really the important
>>>> information in this case.
>>>
>>> Yes, most (all?) uses of _READ and _WRITE macros actually
>>> perform some I/O.
>>
>> I2C_MSG_READ_DATA?
>> I2C_MSG_READ_INFO?
>> I2C_MSG_READ_INIT?
>> I2C_MSG_PREPARE_READ?
>
> Dunno, naming is hard.  Maybe:
>
> I2C_INPUT_MSG
> I2C_OUTPUT_MSG
> I2C_OP_MSG

The current terminology, however, is READ, not INPUT (.flags = I2C_M_RD).

julia
