Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0KCOoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 10:44:03 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:57927 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755379Ab0KCOoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 10:44:02 -0400
Message-ID: <4CD17503.3070604@euromail.se>
Date: Wed, 03 Nov 2010 15:43:15 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 0/8] hwmon: applesmc: Dynamic configuration
 rewrite
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se> <20101103134833.GA12700@ericsson.com>
In-Reply-To: <20101103134833.GA12700@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PDeZ4-0007zx-Bm.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PDeZ4-0007zx-Bm 7048f7788acc99114030f960ac23cf02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 02:48 PM, Guenter Roeck wrote:

> On Sun, Oct 31, 2010 at 03:50:26AM -0400, Henrik Rydberg wrote:
>> The amount of machines supported by this driver has increased rapidly
>> over the past years, and the detailed driver support of the many
>> flavors is quickly becoming a problem.
>>
>> This patchset introduces dynamic configuration by making the SMC
>> register set efficiently searchable, and fixes a number of outstanding
>> issues:
>>
>> * Support for all new models since MacbookPro 6.
>> * Support for variable number of cpu sensors in the MacPros.
>> * Handles the odd temperature sensor types found on new models.
>> * Fixes minor read problems on many intermediate models.
>>
>> The first patch is preparatory. The second patch adds the register
>> lookup cache. The third patch adds the dynamic temperature files, and
>> the fourth implements a new temperature register format. The fifth
>> patch makes the remaining features dynamically configured, and the
>> sixth patch sets up the fans dynamically. The seventh patch is purely
>> janitory, and the last patch updates the copyright.
>>
>> As a side-effect, the file is reduced by almost five hundred lines.
>>
> Henrik,
> 
> since you applied your changes on top of Joe's pr_fmt patch, I assume
> that you Ack that patch. Is that a correct assumption ?
> 
> I know you sent an Ack earlier, but it was "except for comments already made",
> so this is just for clarification.


Yeah, I'm good with those changes. As far as I understand, the issue was
regarding the extra define at the top, not the changes per se. I can certainly
live with that extra line until something better comes along.

Thanks,
Henrik
