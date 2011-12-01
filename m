Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab1LAXiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:38:23 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60390 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755383Ab1LAXiW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:38:22 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <87borsjeez.fsf@laptop.org>
References: <1322283343.14278.2.camel@phoenix> <87borsjeez.fsf@laptop.org>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 2 Dec 2011 07:37:59 +0800
Message-ID: <CAF+7xWnf+wK8EBoGZWNr=9R+WbuAMZbdjjPCP4cubNw8xLyudw@mail.gmail.com>
Subject: Re: [PATCH] mmc: convert drivers/mmc/host/* to use module_platform_driver()
To: Chris Ball <cjb@laptop.org>
Cc: linux-kernel@vger.kernel.org, Micha <mirq-linux@rere.qmqm.pl>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/2 Chris Ball <cjb@laptop.org>:
> Hi Axel, Micha,
>
> On Fri, Nov 25 2011, Axel Lin wrote:
>> This patch converts the drivers in drivers/mmc/host/* to use the
>> module_platform_driver() macro which makes the code smaller and a bit
>> simpler.
>
> This makes cb710_mmc unhappy:
>
> /home/cjb/git/mmc/drivers/mmc/host/cb710-mmc.c:783:1: warning: data definition has no type or storage class [enabled by default]
> /home/cjb/git/mmc/drivers/mmc/host/cb710-mmc.c:783:1: warning: type defaults to ‘int’ in declaration of ‘module_platform_driver’ [-Wimplicit-int]
> /home/cjb/git/mmc/drivers/mmc/host/cb710-mmc.c:783:1: warning: parameter names (without types) in function declaration [enabled by default]
> /home/cjb/git/mmc/drivers/mmc/host/cb710-mmc.c:773:31: warning: ‘cb710_mmc_driver’ defined but not used [-Wunused-variable]

Strange. I don't see above warning in my build after apply this patch.
( Tested on linux-next tree ).

Axel
