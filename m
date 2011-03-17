Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1CQKrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:47:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54736 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753257Ab1CQKrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:47:47 -0400
Message-ID: <4D81E619.9010305@cn.fujitsu.com>
Date: Thu, 17 Mar 2011 18:44:41 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13pre) Gecko/20101113 Shredder/3.1.7pre
MIME-Version: 1.0
To: walter schloegl <sctp@muskelshirt.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: sctp panic
References: <20110317074356.231320@gmx.net> <20110317075445.231310@gmx.net>
In-Reply-To: <20110317075445.231310@gmx.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-17 18:46:19,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-17 18:46:19,
	Serialize complete at 2011-03-17 18:46:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no reproduce steps, no oops info, no sulution.

walter schloegl wrote, at 03/17/2011 03:54 PM:
>> Hi
>>
>> when doing the actions below I get a panic.
>>
>> - echo 1 > /proc/sys/net/sctp/addip_enable 
>> - In a C-Programm  
>>     - socket(AF_INET,SOCK_STREAM,IPPROTO_SCTP);  
>>     - connect(....)     (with correct filled parameters)
>>
>> Its no process (waiting in accept) neccessary
> 
>>> I forgot:
>>> 2.6.32-71.18.1.el6.x86_64 #1 SMP Wed Feb 2 17:49:59 EST 2011 x86_64 x86_64 x86_64 GNU/Linux
> 
>>
>> br
>> walter
>> -- 


-- 

Best Regards
-----
Shan Wei
