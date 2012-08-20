Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab2HTH3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:29:40 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:51813 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2HTH3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:29:38 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <5031E753.5070200@jic23.retrosnub.co.uk>
Date: Mon, 20 Aug 2012 08:29:23 +0100
From: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>
CC: linux-kernel@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 3/3] IIO: arm: Add LRADC to i.MX28 dts
References: <1344784918-32352-1-git-send-email-marex@denx.de> <201208170457.03686.marex@denx.de> <CAAQ0ZWROobdtFkzn9Sr7v5B29zYTQ5YEUZV59kkNE_yv6qbmgQ@mail.gmail.com> <201208191730.31969.marex@denx.de>
In-Reply-To: <201208191730.31969.marex@denx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/08/12 16:30, Marek Vasut wrote:
> Dear Shawn Guo,
>
>> On 17 August 2012 10:57, Marek Vasut <marex@denx.de> wrote:
>>> Thanks ... still, is there some key for those tags? Or do you invent them
>>> at random and then let people guess what's right? Some git grep on
>>> Documentation directory gets me nothing.
>>
>> There is no official document for this.
>
> Hm, maybe such document can be introduced?
Sounds like a voluteer ;) More seriously I suspect it would never get
updated or be correct in the first place. It would be a pile of grief
for whoever was looking after it.

Mostly these prefixes are an excuse for grumpy maintainers to moan
at people :)
>
>> But generally, each subsystem
>> has a convention on the subject prefix, so that the output of git
>> commands like git pull, git shortlog looks consistent on the patch
>> subject, and more importantly people can easily know subsystem the
>> patch touches.
>>
>> The convention for patches touching arch/arm is "ARM: ".
>>
>> Regards,
>> Shawn
>
> Best regards,
> Marek Vasut
>

