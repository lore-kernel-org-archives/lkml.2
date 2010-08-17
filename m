Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab0HQJII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 05:08:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28748 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab0HQJIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 05:08:06 -0400
Message-ID: <4C6A511F.5090407@oracle.com>
Date: Tue, 17 Aug 2010 17:06:39 +0800
From: Tao Ma <tao.ma@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Johannes Stezenbach <js@sig21.net>, linux-fsdevel@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: unable to mount a CD - iso9660 bug?
References: <201008161438.57103.linux@rainbow-software.org> <20100816132151.GA11369@sig21.net> <201008161618.59511.linux@rainbow-software.org> <201008161850.08442.linux@rainbow-software.org>
In-Reply-To: <201008161850.08442.linux@rainbow-software.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ondrej

On 08/17/2010 12:50 AM, Ondrej Zary wrote:
> On Monday 16 August 2010 16:18:57 Ondrej Zary wrote:
>> On Monday 16 August 2010, Johannes Stezenbach wrote:
>>> On Mon, Aug 16, 2010 at 02:38:54PM +0200, Ondrej Zary wrote:
>>>> I have a CD that came with Samsung printer that Linux cannot mount but
>>>> works fine in Windows. The CD is physically OK - "dd" made ISO image
>>>> without any problems. This ISO image is unmountable too. When I force
>>>> the filesystem to iso9660, it mounts but no files are visible:
>>>
>>> Maybe it's a multi-session disk where the first session is
>>> HFS with Apple software.  Try mounting with -t iso9660 -o session=1.
>>
>> Still the same - no files. dmesg contains:
>>
>> ISOFS: Invalid session number or type of track
>> ISOFS: Invalid session number
>> ISO 9660 Extensions: Microsoft Joliet Level 3
>> ISO 9660 Extensions: RRIP_1991A
>
> Here's the compressed ISO file if anyone wants to examine it:
> http://www.rainbow-software.org/linux_files/samsung-bad.rar
what is your kernel version? I can mount it successfully in my el5 box 
with kernel 2.6.35+.

Regards,
Tao
