Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab0CYPie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:38:34 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:53283 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab0CYPic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:38:32 -0400
Message-ID: <4BAB8362.7030005@oracle.com>
Date: Thu, 25 Mar 2010 08:38:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Forest Bond <forest@alittletooquiet.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
       Greg KH <gregkh@suse.de>
Subject: Re: linux-next: Tree for March 24 (staging/vt66*)
References: <20100324161746.85edc5a3.sfr@canb.auug.org.au> <4BAA6B88.2080803@oracle.com> <20100325130003.GB24056@alittletooquiet.net>
In-Reply-To: <20100325130003.GB24056@alittletooquiet.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BAB8368.012F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/10 06:00, Forest Bond wrote:
> Hi,
> 
> On Wed, Mar 24, 2010 at 12:44:08PM -0700, Randy Dunlap wrote:
>> On 03/23/10 22:17, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20100323:
>>
>>
>>
>> (.text+0x5d140): multiple definition of `hostap_set_hostapd'
>> (.text+0x5ccab): multiple definition of `hostap_ioctl'
>>
>> when
>> CONFIG_HOSTAP=y
>> and
>> CONFIG_VT665[56]=y
>>
>> or just both of the latter are =y.
> 
> Is there any way to limit CONFIG_VT665[56] to ("n", "m")?  That would be
> sufficient as a work-around, right?

A driver can be limited to [nm] by adding:
	depends on m

> Or is it preferable to rename the offending functions?

Yes, it's preferable to rename them.

-- 
~Randy
