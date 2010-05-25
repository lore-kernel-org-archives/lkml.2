Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab0EYVS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 17:18:57 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:4149 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758628Ab0EYVS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 17:18:56 -0400
Message-ID: <4BFC3EBA.1090607@gmail.com>
Date: Tue, 25 May 2010 23:18:50 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100403 Lightning/1.0b2pre Shredder/3.0.4
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: davem@davemloft.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-05-25
References: <20100525170401.GE31753@tuxdriver.com> <4BFC331A.9030606@gmail.com> <20100525204235.GA27002@tuxdriver.com>
In-Reply-To: <20100525204235.GA27002@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 May 2010 21:18:50.0934 (UTC) FILETIME=[DF1D5D60:01CAFC4F]
X-RecipientDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/10 22:42, John W. Linville wrote:
> On Tue, May 25, 2010 at 10:29:14PM +0200, Gertjan van Wingerde wrote:
>> On 05/25/10 19:04, John W. Linville wrote:
> 
>>> Gertjan van Wingerde (2):
>>>       rt2x00: Fix rt2800usb TX descriptor writing.
>>
>> The patch causing the breakage this patch fixes wasn't actually upstream yet. So, 
>> applying this patch only is now introducing a bug in 2.6.35. I guess it is better
>> to revert this patch for 2.6.35.
> 
> Hmmm...OK.  Which patch introduces the bug this was intended to fix?
> 

It's this one: 

http://marc.info/?l=linux-wireless&m=127374343617025&w=2

But that patch depends on a number of other unapplied patches :-(, namely:

http://marc.info/?l=linux-wireless&m=127374940425538&w=2
http://marc.info/?l=linux-wireless&m=127374344617058&w=2
and
http://marc.info/?l=linux-wireless&m=127374343217011&w=2

---
Gertjan.
