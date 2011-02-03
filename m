Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1BCVfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:35:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33514
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753130Ab1BCVfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:35:23 -0500
Date: Thu, 03 Feb 2011 13:35:58 -0800 (PST)
Message-Id: <20110203.133558.189694852.davem@davemloft.net>
To: jkosina@suse.cz
Cc: peter.chubb@nicta.com.au, linux-kernel@vger.kernel.org
Subject: Re: tcp_ecn is an integer not a boolean
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1102031126470.2160@pobox.suse.cz>
References: <w4vd12m4it.wl%peter@chubb.wattle.id.au>
	<alpine.LNX.2.00.1102031126470.2160@pobox.suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Thu, 3 Feb 2011 11:26:57 +0100 (CET)

> On Thu, 3 Feb 2011, Peter Chubb wrote:
> 
>> 
>> There was some confusion at LCA as to why the sysctl tcp_ecn took one
>> of three values when it was documented as a Boolean.  This patch fixes
>> the documentation.
>> 
>> Signed-off-by: Peter Chubb <peter.chubb@nicta.com.au>
>> 
>> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
>> index d99940d..ac3b4a7 100644
>> --- a/Documentation/networking/ip-sysctl.txt
>> +++ b/Documentation/networking/ip-sysctl.txt
>> @@ -187,7 +187,7 @@ tcp_cookie_size - INTEGER
>>  tcp_dsack - BOOLEAN
>>  	Allows TCP to send "duplicate" SACKs.
>>  
>> -tcp_ecn - BOOLEAN
>> +tcp_ecn - INTEGER
> 
> Applied, thanks.

There is no need, did you see my reply?  I put it into the net-2.6
GIT tree already.
