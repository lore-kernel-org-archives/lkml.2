Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab0KAVAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:00:16 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:9448 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0KAVAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:00:14 -0400
Message-ID: <4CCF2A5D.6070403@caviumnetworks.com>
Date: Mon, 01 Nov 2010 14:00:13 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Tracey Dent <tdent48227@gmail.com>
CC: Greg KH <greg@kroah.com>, Charles Manning <manningc2@actrix.gen.nz>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/29] Staging: Add yaffs2 filesystem
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>	<201011020814.35902.manningc2@actrix.gen.nz>	<4CCF13FA.1080609@caviumnetworks.com>	<201011020832.16057.manningc2@actrix.gen.nz>	<AANLkTi=XmuhYoiJNGATDEtGyxj7FWH2UCN8QgqcRmEN6@mail.gmail.com>	<20101101201327.GC2049@kroah.com> <AANLkTikjBzaYzOmVz33_d8hazteOZoRY4RF_LjxTTVCf@mail.gmail.com>
In-Reply-To: <AANLkTikjBzaYzOmVz33_d8hazteOZoRY4RF_LjxTTVCf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Nov 2010 21:00:47.0373 (UTC) FILETIME=[DB5B13D0:01CB7A07]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2010 01:46 PM, Tracey Dent wrote:
> On 11/1/10, Greg KH<greg@kroah.com>  wrote:
[...]
>>
>> You need to properly credit _who_ did the code in the first place.  And
>> your patches did not do that at all, which is very bad, and rude, and
>> something that we care deeply about.
>>
>> Please read the file, Documentation/SubmittingPatches for how to
>> properly attribute the author of the patch when you send it out.
>>
>> I'm not going to take this as-is because of this problem, and neither
>> will any other maintainer.  Someone can resend it with the proper author
>> and signed-off-by stuff and I'll be glad to look at it again then.
>>
>
> Sorry for not giving credit. I will resend following patch set with
> proper credits.
>

It is not a race to see who can spam lkml first.  Please consider 
coordinating with Charles, and perhaps even defer to him if he wishes to 
send the patches (or even have them pulled from his git repository).

David Daney.
