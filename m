Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab0KSRuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 12:50:08 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53976 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab0KSRuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 12:50:07 -0500
Message-ID: <4CE6B87C.2010203@oracle.com>
Date: Fri, 19 Nov 2010 09:48:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Pavel Machek <pavel@ucw.cz>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] staging: fix winbond build, needs delay.h
References: <20101119143207.b2d5731e.sfr@canb.auug.org.au> <20101119093018.340dab03.randy.dunlap@oracle.com> <20101119173831.GA6098@suse.de>
In-Reply-To: <20101119173831.GA6098@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/10 09:38, Greg KH wrote:
> On Fri, Nov 19, 2010 at 09:30:18AM -0800, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> winbond drivers use msleep() and delay(), so include linux/delay.h
>> in a common header file to prevent build errors.
>>
>> drivers/staging/winbond/phy_calibration.c:987: error: implicit declaration of function 'msleep'
>> drivers/staging/winbond/phy_calibration.c:1556: error: implicit declaration of function 'udelay'
>> drivers/staging/winbond/reg.c:894: error: implicit declaration of function 'msleep'
>> drivers/staging/winbond/reg.c:1178: error: implicit declaration of function 'udelay'
> 
> Is this error showing up in Linus's tree, or only in linux-next?

I saw it in linux-next, but it looks like it should also be a build error
in mainline.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
