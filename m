Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab2CMPxX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:53:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43378 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab2CMPxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:53:21 -0400
Date: Tue, 13 Mar 2012 10:53:07 -0500 (CDT)
From: Manoj Iyer <manoj.iyer@canonical.com>
X-X-Sender: manjo@lazy
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: Yves-Alexis Perez <corsac@debian.org>,
        ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        James Ferguson <james.ferguson@canonical.com>,
        Dennis Chua <dennis.chua@canonical.com>,
        Ike Pan <ike.pan@canonical.com>
Subject: Re: [ibm-acpi-devel] [PATCH] thinkpad-acpi: recognize Lenovo as
 version string in newer V-series BIOS
In-Reply-To: <alpine.DEB.2.02.1203121852500.6421@lazy>
Message-ID: <alpine.DEB.2.02.1203131046540.4292@lazy>
References: <1331335944-4662-1-git-send-email-manoj.iyer@canonical.com> <1331335944-4662-2-git-send-email-manoj.iyer@canonical.com> <20120310042844.GA14972@khazad-dum.debian.net> <1331387907.2833.33.camel@scapa> <20120310160609.GA6254@khazad-dum.debian.net>
 <alpine.DEB.2.02.1203121558340.3458@lazy> <20120312230213.GA20690@khazad-dum.debian.net> <alpine.DEB.2.02.1203121852500.6421@lazy>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012, Manoj Iyer wrote:

>>> 
>>> I am trying to get this patched module tested on other thinkpad and
>>> ideapads that we have to see if there are any regression or other
>>> issues. So, please let me know if this something worth supporting.
>> 
>> Yes, it looks like it is worth supporting alright.
>
> ok great. So, as I said earlier I will try and get this patched module tested 
> on other ideapads to make sure we are not breaking existing systems. 
> Unfortunately the systems are with our Taiwan engineers and will take a 
> couple of days for them to get back with results.

The patch was tested by the following people on ThinkPads, V480, and 
ideapads, and found to work as expected. I am informed that it does not 
break existing thinkpads, and it fixes issues mentioned on the V480. Can 
you please add the following tested-by when you apply the patch to your 
tree?

Tested-by: James Ferguson <james.ferguson@canonical.com>
Tested-by: Dennis Chua <dennis.chua@canonical.com>
Tested-by: Ike Pan <ike.pan@canonical.com>


>
>> 
>> --
>>  "One disk to rule them all, One disk to find them. One disk to bring
>>  them all and in the darkness grind them. In the Land of Redmond
>>  where the shadows lie." -- The Silicon Valley Tarot
>>  Henrique Holschuh
>> 
>> 
>
> --
> ====================
> Manoj Iyer
> Ubuntu/Canonical
> Hardware Enablement
> ====================
>
>

--
====================
Manoj Iyer
Ubuntu/Canonical
Hardware Enablement
====================
