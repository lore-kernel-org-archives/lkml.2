Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab0FOJyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 05:54:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:38273 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab0FOJyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 05:54:06 -0400
Message-ID: <4C174DBB.9000901@suse.cz>
Date: Tue, 15 Jun 2010 11:54:03 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, stefani@seibold.net
Subject: Re: [PATCH] tags: put function prototypes back!
References: <20100203201816.GA5987@x200> <20100615092230.GA21819@pengutronix.de>
In-Reply-To: <20100615092230.GA21819@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.6.2010 11:22, Uwe Kleine-König wrote:
> On Wed, Feb 03, 2010 at 10:18:17PM +0200, Alexey Dobriyan wrote:
>> commit 7db86dc97fb0c47af63e6b965e8ff37126050d25
>> "ctags: usability fix" removed function prototypes from tags file
>> claiming "It makes no real sense to include function prototypes".
>> But it is useful for quickly determining which header file developer
>> needs to include to fix compilation.
>>
>> Now if someone wants to remove forward declatations (which I agree are
>> baggage), write a postprocessing script.
>>
>> Please apply.
>>
>> 	Alexey, who is sick reverting this chunk locally.
>>
>> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Alexey, can you please resend the patch? I don't see it in the archives
anywhere.

Thanks,
Michal
