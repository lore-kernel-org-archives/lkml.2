Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0HZPKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 11:10:15 -0400
Received: from slowhand.arndnet.de ([88.198.19.76]:37289 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752012Ab0HZPKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 11:10:13 -0400
Message-ID: <4C7683D3.5090500@nets.rwth-aachen.de>
Date: Thu, 26 Aug 2010 17:10:11 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Piotr Hosowicz <piotr@hosowicz.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Which kernel.org WWW is the master server?
References: <4C6D4864.2040002@example.com> <alpine.LRH.2.00.1008261536290.2372@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.1008261536290.2372@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.08.2010 15:37, schrieb Jiri Kosina:
> On Thu, 19 Aug 2010, Piotr Hosowicz wrote:
>
>   
>> I wrote a simple python script that tells me that a new kernel version
>> appeared. The problem is that it is based exactly on this what appears on the
>> webpage so sometimes it resolves the server IP that the version has changed,
>> despite the fact that it is not true. Which server is the master server?
>>     
> I guess that simply running
>
> 	finger @kernel.org
>
> will give you exactly the information you are looking for which much less 
> pain of connecting to www server, parsing html, etc.
>   

Not sure if this is still accurate:

> Aug 21, 2003: Please don't use *finger.kernel.org* for any sort of
> automatic monitoring. The number of automatic bots hitting this port
> is causing the finger daemon to shut down more often than not. The
> same information is available from
> http://www.kernel.org/kdist/finger_banner
> <http://kernel.org/kdist/finger_banner>. 

Regards,
Arnd
