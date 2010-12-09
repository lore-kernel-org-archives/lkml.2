Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956Ab0LIS04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:26:56 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:45475 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756941Ab0LIS0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:26:53 -0500
Message-ID: <4D011EA3.2000905@euromail.se>
Date: Thu, 09 Dec 2010 19:23:31 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] input: mt updates for 2.6.38
References: <4CFF49BC.8030202@euromail.se> <20101209085814.GA8821@core.coreip.homeip.net>
In-Reply-To: <20101209085814.GA8821@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PQl9Q-0008N0-6E.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PQl9Q-0008N0-6E 4827eff91645635fdf98a223cba7bc69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 09:58 AM, Dmitry Torokhov wrote:

> On Wed, Dec 08, 2010 at 10:02:52AM +0100, Henrik Rydberg wrote:
>> Dmitry,
>>
>> Please pull from
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git next
>>
>> to receive input-mt updates for 2.6.38.
>>
>> The tree contains core changes as well as dependent changes to hid drivers. You
>> also find the new hid-egalax driver in there, signed off by Jiri.
> 
> Pulled, thank you Henrik.
> 
> I wonder if we should move input-mt.h into input/mt.h (and if someone
> would bother to input-polldev.h there that would be great too).


Sure, I have been wondering about that too. Right away, or later?

> Also I try to sync with mainline once per release, at -rc1, unless I
> know that my changes will conflict with some other work. I'd recommend
> you do the same so that when I pull from you I am getting just your
> changes and not the rest of stuff from mainline.


No problem - I will see what sync point you end up using, and I will rebase to
the same point.

> BTW, we need to document dev->trkid to avoid complaints from 'make
> htmldocs' and friends. I wonder if the patch below will do.


Looks good, thanks.

Henrik
