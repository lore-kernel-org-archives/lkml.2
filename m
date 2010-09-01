Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab0IALcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 07:32:55 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:45830 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751103Ab0IALcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 07:32:53 -0400
Message-ID: <4C7E39CC.80402@euromail.se>
Date: Wed, 01 Sep 2010 13:32:28 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100820 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephane Chatty <chatty@enac.fr>
Subject: Re: [PATCH] hid: Add a hid quirk for input sync override
References: <1282640084-19217-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1009011252450.26813@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1009011252450.26813@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OqlYY-0002pn-74.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1OqlYY-0002pn-74 a4a671f4cb542b076e363c28e17edd65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2010 12:54 PM, Jiri Kosina wrote:

> On Tue, 24 Aug 2010, Henrik Rydberg wrote:
> 
>> From: Henrik Rydberg <rydberg@thabit.(none)>
>>
>> As of lately, HID devices which send per-frame data split over several
>> HID reports have started to emerge. This patch adds a quirk which
>> allows the HID driver to take over the input layer synchronization,
>> and hence the control of the frame boundary.
>>
>> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>> ---
>> Jiri, Dmitry, Stephane,
>>
>> No doubt, this is not a final solution, but it serves the purpose of
>> being able to make existing drivers functional while a satisfactory
>> solution is being worked out.
> 
> Hi Henrik,
> 
> I obviously don't have any major objections to the patch, as it was my 
> initial idea :)


Ah! Then all is fine. :-)

> 
> I'd like to merge it together with driver which actually uses it though.


Sounds good. I suppose Stephane wants to have a say regarding the 3m driver
first, but no rush. What version are you targeting?

Thanks,
Henrik
