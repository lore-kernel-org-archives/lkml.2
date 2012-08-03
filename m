Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab2HCMEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 08:04:43 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:26692 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab2HCMEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 08:04:38 -0400
X-Authority-Analysis: v=2.0 cv=QrvcLCOd c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=sgO5gNtQRqEA:10 a=wkBGhNO-IO0A:10 a=05ChyHeVI94A:10 a=8nJEP1OIZ-IA:10 a=ayC55rCoAAAA:8 a=EBLMUHSpj4vwrOWlgvcA:9 a=wPNLvfGTeEIA:10 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <501BBE45.8060309@cfl.rr.com>
Date: Fri, 03 Aug 2012 08:04:21 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Chris Friesen <chris.friesen@genband.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_LICENSE("GPL")??
References: <50199E91.5040308@cfl.rr.com> <20120801224342.5b90747f@pyramind.ukuu.org.uk> <501A704E.2000301@cfl.rr.com> <501B5D51.5030307@genband.com>
In-Reply-To: <501B5D51.5030307@genband.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 01:10 AM, Chris Friesen wrote:
> On 08/02/2012 06:19 AM, Mark Hounschell wrote:
>>
>> This particular driver  does in fact build cleanly after changing the GPL
>> to PROPRIETARY. I haven't actually purchased the product yet so am unable
>> to load it, but can I assume that if I don't have a build issue when
>> specifying PROPRIETARY, that they are in fact NOT using GPL symbols and
>> maybe they just thought they needed to specify GPL for some reason or
>> another?
>
> Why not just ask the authors?
>

Well, I will before I actually distribute it to anyone. It's still not set 
in stone that I'm going to use their product but since I now know that it 
at least builds as NOT GPL, I just thought someone here could confirm my 
assumption that that actually meant they were NOT using GPL symbols.

Thanks
Mark
