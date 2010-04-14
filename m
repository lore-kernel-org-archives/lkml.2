Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab0DNAOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 20:14:21 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:35400 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab0DNAOT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 20:14:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=BMJYAlP7MR+K427uC5zkNoKmXLVXNcFQbrZ8ulbDLlfNRsV/ynf1l2o3P0bt+iKFUE
         4AU5g1g0sfD7wmijKDt4AjRkSRbw7Atpx79sGfq4K34xWJDHr4yHvU1HJqfga1h/q22i
         7WtEic3ChOSwssoVVDyEdI3Z+fZCcupKOgCsY=
MIME-Version: 1.0
In-Reply-To: <201004140119.53687.PeterHuewe@gmx.de>
References: <y2qa5d587fb1004131613obfc84dc2yd862cd79d7a3b084@mail.gmail.com> 
	<201004140119.53687.PeterHuewe@gmx.de>
From: Michal Suchanek <hramrach@centrum.cz>
Date: Wed, 14 Apr 2010 02:13:57 +0200
X-Google-Sender-Auth: ed2f1e7b832d56aa
Message-ID: <h2ga5d587fb1004131713q46b6364ek7f887066a7a9f160@mail.gmail.com>
Subject: Re: Parallel port LCD driver undocumented
To: =?UTF-8?Q?Peter_H=C3=BCwe?= <PeterHuewe@gmx.de>
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Willy Tarreau <w@1wt.eu>, willy@meta-x.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 April 2010 01:19, Peter Hüwe <PeterHuewe@gmx.de> wrote:
> Am Mittwoch 14 April 2010 01:13:40 schrieb Michal Suchanek:
>> Hello
>>
>> I was thinking about adding a LCD to my PC so I thought that the
>> panel.c driver which just went to 2.6.34 would be helpful.
>>
>> The problem is there is no documentation. I can get quite detailed
>> documentation for at least some LCDs that are sold around here but
>> there is not enough documentation for the driver to determine if the
>> LCD in question would be compatible with the driver and with which
>> protocol.
>>
>> Detailed explanation of the parameters would be appreciated. For
>> example, there are three parallel protocols supported but there is no
>> description of the difference between them.
>>
>> Thanks
>
> Hi,
> I CC'ed willy - the original author of the driver - maybe he can help out.
>
>
> Meanwhile - did you have a look at LCDproc?
> http://lcdproc.org/
> Userspace "drivers" for a lot of lcds and keypads.

Yes, after some thinking I figured that a software that I put in the
initramfs could possibly drive the display even without much kernel
support.

With a working in-kernel driver I could get something displayed a bit
earlier still.

More importantly there is the question of displaying something useful
on the display. With an in-kernel driver it should not be overly
difficult to add support for echoing what goes to the console on the
display as well. With a separate software I have no idea how to
collect some reasonably useful information.

I mean, if the machine is running correctly I can easily ssh in and
run full suite of analytic tools and fill my monitor with various
useless information about the system. It's the case when something
does not seem to work when the display would come handy.

Thanks

Michal
