Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1ANKxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 05:53:13 -0500
Received: from 26.mail-out.ovh.net ([91.121.27.225]:48296 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751152Ab1ANKxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 05:53:06 -0500
Message-ID: <4D302B0E.1080306@example.com>
Date: Fri, 14 Jan 2011 11:53:02 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: balbi@ti.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: error in 2.6.37-git10
References: <4D301CA5.503@example.com> <20110114095745.GD2476@legolas.emea.dhcp.ti.com> <4D302067.2000203@example.com> <20110114100831.GE2476@legolas.emea.dhcp.ti.com> <4D3021AE.5020607@example.com>
In-Reply-To: <4D3021AE.5020607@example.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 3102698669477753202
X-Ovh-Remote: 83.24.79.226 (dmx226.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.01.2011 11:13, Piotr Hosowicz wrote:
> On 14.01.2011 11:08, Felipe Balbi wrote:
>> On Fri, Jan 14, 2011 at 11:07:35AM +0100, Piotr Hosowicz wrote:
>>> On 14.01.2011 10:57, Felipe Balbi wrote:
>>>> On Fri, Jan 14, 2011 at 10:51:33AM +0100, Piotr Hosowicz wrote:
>>>>> Hello,
>>>>>
>>>>> Build failed here:
>>>>>
>>>>> CC [M] fs/ecryptfs/main.o
>>>>> fs/ecryptfs/main.c:144: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
>>>>> ‘__attribute__’ before ‘*’ token
>>>>> fs/ecryptfs/main.c: In function ‘ecryptfs_interpose’:
>>>>> fs/ecryptfs/main.c:204: error: implicit declaration of function
>>>>> ‘ecryptfs_get_inode’
>>>>> fs/ecryptfs/main.c:204: warning: initialization makes pointer from
>>>>> integer without a cast
>>>>> fs/ecryptfs/main.c:206: error: expected ‘)’ before ‘return’
>>>>> fs/ecryptfs/main.c:212: error: expected expression before ‘}’ token
>>>>> fs/ecryptfs/main.c: In function ‘ecryptfs_mount’:
>>>>> fs/ecryptfs/main.c:569: warning: assignment makes pointer from
>>>>> integer without a cast
>>>>
>>>> Could you check whether this is enough?
>>>
>>> I am building now with this option disabled, maybe I'll have time to
>>> test again.
>>
>> I just did. Compiled only that module with that header added. Built
>> cleanly.
>
> I corrected and am building again. Hope this helps.

I don't know why but it failed again. I disabled and am building again.

Regards,

Piotr Hosowicz

-- 
Janusz Korwin-Mikke:
"ZUS z pewnością jest instytucją przestępczą,
ale nie można nazwać jej zorganizowaną."
NP: Patrick O'Hearn - Approaching Summit
NB: 2.6.37-20110113-1411-pztidm+
