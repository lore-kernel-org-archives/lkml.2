Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab2JGVuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 17:50:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48804 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2JGVuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 17:50:00 -0400
Message-ID: <5071F902.6050308@gmail.com>
Date: Mon, 08 Oct 2012 08:49:54 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Julia Lawall <julia.lawall@lip6.fr>, walter harms <wharms@bfs.de>,
        Antti Palosaari <crope@iki.fi>, kernel-janitors@vger.kernel.org,
        shubhrajyoti@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] drivers/media/tuners/e4000.c: use macros for i2c_msg
 initialization
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>  <1349624323-15584-3-git-send-email-Julia.Lawall@lip6.fr>  <5071AEF3.6080108@bfs.de>  <alpine.DEB.2.02.1210071839040.2745@localhost6.localdomain6>  <5071B834.1010200@bfs.de>  <alpine.DEB.2.02.1210071917040.2745@localhost6.localdomain6>  <1349633780.15802.8.camel@joe-AO722>  <alpine.DEB.2.02.1210072053550.2745@localhost6.localdomain6> <1349645970.15802.12.camel@joe-AO722>
In-Reply-To: <1349645970.15802.12.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/12 08:39, Joe Perches wrote:
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

Well, they are describing an IO operation even if they don't perform it
directly. What else would you call them? I think the macro names are
fine as is.

~Ryan

