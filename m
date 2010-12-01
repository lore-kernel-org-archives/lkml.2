Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab0LAOtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:49:39 -0500
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:40944 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173Ab0LAOti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:49:38 -0500
Message-ID: <4CF6604E.8080109@blueyonder.co.uk>
Date: Wed, 01 Dec 2010 14:48:46 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6 ThunderBrowse/3.3.2
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        opensuse factory list <opensuse-factory@opensuse.org>
Subject: Re: 2.6.37-rc3-git installed modules zero bytes long
References: <4CF5116B.8040204@blueyonder.co.uk> <20101130154855.GA4629@hack> <4CF53364.1090807@blueyonder.co.uk> <20101201060704.GD5210@cr0.nay.redhat.com>
In-Reply-To: <20101201060704.GD5210@cr0.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/10 06:07, Américo Wang wrote:
>
> (Please don't drop lkml, and I am not a subscriber of the opensuse list.)
>
OK. I built 2.6.37-rc3-git7-smp on the second box, checked the modules 
were OK. Rebooted and modules were still OK, built the NVidia module, 
rebooted and it's OK.
I didn't build VirtualBox-3.2-3.2.10_66523 modules this time to 
eliminate that as the problem previously appeared after I had rebuilt 
VBox as the last action before rebooting straight into X.

I'm now building 2.6.37-rc4-git1 and I shall repeat that sequence again.
Regards
Sid.

> On Tue, Nov 30, 2010 at 05:24:52PM +0000, Sid Boyce wrote:
>> On 30/11/10 15:48, AmÃ©rico Wang wrote:
>>> On Tue, Nov 30, 2010 at 02:59:55PM +0000, Sid Boyce wrote:
>>>> openSUSE 11.3 on one box and openSUSE 11.4 Milestone 4 on the other.
>>>> I have a message that says the built modules not found. When I check e.g
>>>> /lib/modules/2.7.37-rc3-git7-smp, most modules are zero bytes long.
>>>> I have to "make modules_install" and use modprobe on each.
>>>> To get the network up on the 11.3 box "modprobe r6189" then "rcnetwork
>>>> restart", "modprobe rtl8187", "/etc/init.d/network-remotefs start",
>>>> etc., etc.
>>>
>>> Confused, shouldn't we always run 'make modules_install'?
>>> What did you do before that?
>>>
>>
>> As usual a script that does the following and never had problems
>> before. It says it's installed the modules, but a check shows they
>> are all zero bytes long.
>> -------------------------------------------------------------------
>> #!/bin/sh
>> make -j 4 clean&&  make headers_install&&  make -j 4&&  make -j 4
>> modules_install
>> -------------------------------------------------------------------
>
> Hmm, nothing is wrong with this script.
>
> Sounds like a regression, but I don't recall we have any 'module_install'
> changes recently.
>
> What does 'make V=2 modules_install' output?
>
> Thanks.
>


-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

