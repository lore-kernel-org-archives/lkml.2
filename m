Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab0LTRZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:25:07 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:40846 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab0LTRZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:25:05 -0500
Message-ID: <4D0F914F.2050908@oracle.com>
Date: Mon, 20 Dec 2010 09:24:31 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?UGV0ZXIgSMO8d2U=?= <PeterHuewe@gmx.de>
CC: sedat.dilek@gmail.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] platform/x86: Fix recursive Kconfig dependency
References: <1291850970-7190-1-git-send-email-peterhuewe@gmx.de> <201012192000.14969.PeterHuewe@gmx.de> <AANLkTi=gqimS5n6J6GXcZA_W1JHZ8yHJHAKqP=dDmN0Z@mail.gmail.com> <201012201809.41269.PeterHuewe@gmx.de>
In-Reply-To: <201012201809.41269.PeterHuewe@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/10 09:09, Peter Hüwe wrote:
> Am Montag 20 Dezember 2010, 15:46:02 schrieb Sedat Dilek:
>>> Added Stephen Rothwell on CC, maybe he can apply it directly to
>>> linux-next ;)
>>>
>>> Peter
>>
>> I do not think this will happen for a "as-warning-classified" patch.
> 
> On arm and avr32 it is not only a warning but an error instead!
> 
> -> so the patch fixes an error / build failure which imho is quite an 
> important issue.
> 
> You can see the errors in Ellerman's build farm.
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/3652816/
> http://kisskb.ellerman.id.au/kisskb/buildresult/3664077/
> http://kisskb.ellerman.id.au/kisskb/buildresult/3652972/
> http://kisskb.ellerman.id.au/kisskb/buildresult/3664113/
> 
> As it is an error for arm and avr32 maybe it should go through their trees 
> instead?


It's a kconfig "error" on x86 also, but it does not stop the .config file
from being generated.  It needs to be fixed, but it's not deadly.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
