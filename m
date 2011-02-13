Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab1BMWM1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 17:12:27 -0500
Received: from paneer.cc.columbia.edu ([128.59.29.4]:43749 "EHLO
	paneer.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab1BMWMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 17:12:21 -0500
Message-ID: <4D585729.5040400@rath.org>
Date: Sun, 13 Feb 2011 17:11:53 -0500
From: Nikolaus Rath <Nikolaus@rath.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Brice Goglin <Brice.Goglin@ens-lyon.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: virt_to_page for userspace pointers
References: <87k4hgn8qa.fsf@inspiron.ap.columbia.edu>	<878vxuxkfr.fsf@inspiron.ap.columbia.edu>	<4D4DC2D6.8030905@ens-lyon.org>	<4D583E17.80606@rath.org>	<4D5840F6.8030401@ens-lyon.org>	<4D58537C.3020409@rath.org> <20110213220608.0c4b0cc2@lxorguk.ukuu.org.uk>
In-Reply-To: <20110213220608.0c4b0cc2@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2011 05:06 PM, Alan Cox wrote:
>>> If you don't lock the page, you have no guarantee that it won't get
>>> swapped out or migrated while you look at the physical page.
>>
>> That's fine, I know that if the page is there at all then it has been
>> locked by a (different) kernel driver. Is there any way to find out what
>> I want?
> 
> How do you know the other driver isn't in the middle of releasing the
> page ? Doing that deep in mm code without locking inversions will be fun.

I have complete control over the environment, and I know that my code
will only be called after the other driver has set up the mapping and
the mapping will continue to exist until my code returns.

Please let me risk to shoot myself in the foot, just tell me if there is
a function to do so.. I take full responsibility.


Thanks,

   -Nikolaus

-- 
 »Time flies like an arrow, fruit flies like a Banana.«

  PGP fingerprint: 5B93 61F8 4EA2 E279 ABF6  02CF A9AD B7F8 AE4E 425C
