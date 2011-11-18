Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab1KROy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 09:54:58 -0500
Received: from oceanic.CalvaEDI.COM ([89.202.194.168]:55486 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab1KROy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 09:54:57 -0500
Message-ID: <4EC671BB.4080805@Calva.COM>
Date: Fri, 18 Nov 2011 15:54:51 +0100
From: John Hughes <john@Calva.COM>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Luk Claes <luk@debian.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add "-e" option to rpc.gssd to allow error on ticket
 expiry
References: <4EC6426A.3020306@Calva.COM> <4EC66148.4020003@RedHat.com> <4EC664D3.9030402@Calva.COM> <4EC67021.6060905@debian.org>
In-Reply-To: <4EC67021.6060905@debian.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/11/11 15:48, Luk Claes wrote:
> On 11/18/2011 02:59 PM, John Hughes wrote:
>>
>> Okeydoke, let's see, where's the man page...
>>
>> $ find  /usr/share/man* -name 'rcp.gssd*'
>>
>> find: cannot get current directory: Permission denied
> rcp != rpc

The joke was that I was using the patched rpc.gssd and my (deliberately 
short life) ticket had expired, so find bitched about not being able to 
read my home directory.

And I made a typo.  What a maroon I am.

