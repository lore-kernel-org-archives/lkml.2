Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab2ENVeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:34:14 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:61903 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab2ENVeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:34:13 -0400
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2012 17:34:13 EDT
X-Loopcount0: from 10.9.160.253
Message-ID: <4FB1774D.4080106@dell.com>
Date: Mon, 14 May 2012 16:21:17 -0500
From: Mario Limonciello <mario_limonciello@dell.com>
Organization: Dell Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Kamal Mostafa <kamal@canonical.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dell-laptop: rfkill blacklist Dell XPS 13z, 15z
References: <1337023652-11661-1-git-send-email-kamal@canonical.com> <20120514193718.GA6438@srcf.ucam.org> <4FB16659.6040704@dell.com> <20120514211959.GA9394@srcf.ucam.org>
In-Reply-To: <20120514211959.GA9394@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/14/2012 04:19 PM, Matthew Garrett wrote:
> On Mon, May 14, 2012 at 03:08:57PM -0500, Mario Limonciello wrote:
>> On 05/14/2012 02:37 PM, Matthew Garrett wrote:
>>> What does "Improper BIOS interaction" mean? What's the proper BIOS interaction?
>> These platforms are not obeying the smbios interface specs for turning on and off radios.  It's not currently expected that the interaction will improve during the lifetime of these platforms.  If it does, then this can be adjusted to only apply to the BIOS versions before the fix.
> Ok, pretty bored of this at this point. If the bios interface is
> unreliable then I'll just remove the rfkill support. I'm not going to
> continue adding machines to a blacklist some time after users find
> things are broken.
>
> Is this just as broken under Windows?
>
The BIOS interface is reliable on business client (Latitude and Vostro) hardware.

The outliers of Inspiron and XPS don't seem to follow the interface as explicitly.  It is not broken on Windows.  I don't have an understanding why it's not, but conjecture that it's a different interface being used on these that I don't have information on yet.

You would be better to only match on Latitude and Vostro and anything else that people want to opt in via a paramater than to remove the interface entirely IMO.

-- 
*Mario Limonciello*
Linux Engineer
*Dell*| OS Engineering
