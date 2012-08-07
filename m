Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab2HGQ43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 12:56:29 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:40626 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755018Ab2HGQ41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 12:56:27 -0400
Message-ID: <5021486B.6020907@xenotime.net>
Date: Tue, 07 Aug 2012 09:55:07 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Salar Ali Mumtaz <salaarali@gmail.com>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xconfig: Display dependency values in debug_info
References: <1343256982-11421-1-git-send-email-salaarali@gmail.com> <50107EB7.8000009@xenotime.net> <CA+jpPM=nrbpDJpaka6xAp4dbEOQjJrtwQWtUXwi_gGS9b4yK-A@mail.gmail.com> <50117812.5080302@xenotime.net> <50213D69.3060904@gmail.com>
In-Reply-To: <50213D69.3060904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 09:08 AM, Salar Ali Mumtaz wrote:

> On 12-07-26 01:02 PM, Randy Dunlap wrote:
> 
>> The added y/n/m are clear, but the "!FRV FRV" is confusing,
>> isn't it?
>>
>>
> 
> Is this notation clear ?
> 
> Kernel support for ELF binaries (BINFMT_ELF)
> 
> type: boolean
> unknown property: symbol
>     dep: ( MMU [=y] && (BROKEN [n] || !FRV [= ""]) ) [=y]
> prompt: Kernel support for ELF binaries
>     dep: ( MMU [=y] && (BROKEN [n] || !FRV [= ""]) ) [=y]
> default: y
>     dep: ( MMU [=y] && (BROKEN [n] || !FRV [= ""]) ) [=y]



In Kconfig language, is "" the same as 'n' ?
If so, I'm OK with your proposal above.


> If not, could you suggest a better way to represent this information?
> 
> Thanks.



thanks,
-- 
~Randy
