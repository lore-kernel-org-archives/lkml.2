Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab0EQHlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 03:41:45 -0400
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:55208 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab0EQHlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 03:41:44 -0400
Message-ID: <4BF0F334.8090108@blueyonder.co.uk>
Date: Mon, 17 May 2010 08:41:40 +0100
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.15 Thunderbird/3.0.4 ThunderBrowse/3.2.8.1
MIME-Version: 1.0
CC: piotr@hosowicz.com, LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: General questiin about SYSFS
References: <4BF05EC9.6070102@blueyonder.co.uk> <4BF0AA6C.1050102@example.com>
In-Reply-To: <4BF0AA6C.1050102@example.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/05/10 03:31, Piotr Hosowicz wrote:
> On 16.05.2010 23:08, Sid Boyce wrote:
>> As the message says, you have to change all instances of SSYSFS to ATTR
>>   in the rules files in /etc/udev/rules.d to stop those messages
>> appearing on boot up.
> 
> Ok, forget my next question - I risked breaking things and made a plain
> search and replace, reboot, things seem to work, no errors. I also had
> to change BUS to SUBSYSTEM.
> 
> Regards,
> 
> Piotr Hosowicz
> 

I forgot to mention the BUS to SUBSYSTEM  change, but it was obvious
when looking at the messages. One other I've seen (on openSUSE 11.3),
/etc/modprobe.conf deprecated, so I've moved it out of /etc and also
changed files in /etc/modprobe.d from xxxxxxx to xxxxxxx.conf. It all
helps keep the noise down.
No problems, I have been running with the modified files for some months.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

