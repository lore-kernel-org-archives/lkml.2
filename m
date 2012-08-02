Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab2HBGKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 02:10:17 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:52373 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752609Ab2HBGKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 02:10:15 -0400
Message-ID: <501A067E.4070101@xenotime.net>
Date: Wed, 01 Aug 2012 21:47:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Salar Ali Mumtaz <salaarali@gmail.com>
CC: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xconfig: Display dependency values in debug_info
References: <1343256982-11421-1-git-send-email-salaarali@gmail.com> <50107EB7.8000009@xenotime.net> <CA+jpPM=nrbpDJpaka6xAp4dbEOQjJrtwQWtUXwi_gGS9b4yK-A@mail.gmail.com> <50117812.5080302@xenotime.net> <50182ACF.6070704@gmail.com> <50183E67.1060509@xenotime.net> <501A0012.2070508@gmail.com>
In-Reply-To: <501A0012.2070508@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 09:20 PM, Salar Ali Mumtaz wrote:

> On 12-07-31 04:21 PM, Randy Dunlap wrote:
>> On 07/31/2012 11:58 AM, Salar Ali Mumtaz wrote:
>>
>>> Now the debug_info only shows y/n/m values.
>>>
>>
>>
>> or no value at all??
> 
> 
> Yes.
> 
> y/n/m or no value at all.
> 


so in:

Kernel support for ELF binaries (BINFMT_ELF)

type: boolean
unknown property: symbol
    dep: ( MMU y && (BROKEN n || !FRV ) ) =y
prompt: Kernel support for ELF binaries
    dep: ( MMU y && (BROKEN n || !FRV ) ) =y
default: y
    dep: ( MMU y && (BROKEN n || !FRV ) ) =y



does that mean that FRV is n, so !FRV is y ??
It's still confusing.


-- 
~Randy
