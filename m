Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab0LISBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:01:06 -0500
Received: from imp01.mtu.ru ([62.5.255.10]:60580 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441Ab0LISA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:00:59 -0500
Message-ID: <4D011913.7090501@pavlinux.ru>
Date: Thu, 09 Dec 2010 20:59:47 +0300
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 PAVLINUX/7.7.7 0xDEADBEEF/7.7.7
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Sysctl interface to UNIX_INFLIGHT_TRIGGER_GC v.2
References: <4D004E42.7000807@pavlinux.ru>	<20101209041310.GA5101@cr0.nay.redhat.com>	<4D00BE59.4090109@pavlinux.ru> <20101209090428.6da9198c.randy.dunlap@oracle.com>
In-Reply-To: <20101209090428.6da9198c.randy.dunlap@oracle.com>
X-Enigmail-Version: 1.1.2
OpenPGP: id=03742489
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.12.2010 20:04, Randy Dunlap wrote:
> On Thu, 09 Dec 2010 14:32:41 +0300 Pavel Vasilyev wrote:
>>>> Maybe something to add in Documentation/kernel-parameters.txt ?
>>> No, that is for boot parameters, you need to find something like
>>> Documentation/networking/ip-sysctl.txt.
>>
>> Thanks, added.
> 
> Now you need to send this to netdev@vger.kernel.org so that the netdev
> people can review it.  Please.
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***

http://www.spinics.net/lists/netdev/msg149397.html

-- 

                                                         Pavel.
