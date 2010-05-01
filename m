Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab0EASoQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 14:44:16 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:37250 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756967Ab0EASoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 14:44:14 -0400
Message-ID: <4BDC7668.2010005@euromail.se>
Date: Sat, 01 May 2010 20:43:52 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] hwmon: applesmc: Add generic support for MacBook
 Pro 7
References: <1272663486-16945-1-git-send-email-rydberg@euromail.se>	<1272663486-16945-2-git-send-email-rydberg@euromail.se>	<1272663486-16945-3-git-send-email-rydberg@euromail.se> <20100501204021.7d65542b@hyperion.delvare>
In-Reply-To: <20100501204021.7d65542b@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1O8HfN-0000jb-3v.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1O8HfN-0000jb-3v 1000252de011840496a3a18ac54fb29b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:
> Hi Henrik,
> 
> On Fri, 30 Apr 2010 23:38:06 +0200, Henrik Rydberg wrote:
>> This patch adds generic support for the MacBook Pro 7 family
>> based on the 7,1 model.
>>
>> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>> ---
>>  drivers/hwmon/applesmc.c |    9 +++++++++
>>  1 files changed, 9 insertions(+), 0 deletions(-)
>> (...)
> 
> All 3 patches applied. I guess they can be scheduled for merge in
> 2.6.35-rc1?
> 

Yep, 2.6.35-rc1 is just fine. Thanks!

Henrik

