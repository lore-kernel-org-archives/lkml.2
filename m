Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1KCIZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 04:25:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60891 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752238Ab1KCIZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 04:25:11 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1+T4B9myNCTwMuFRHMzXQu+gn4U0id5+teU0z1VmB
	bud6b2NjpORX42
From: Sven Joachim <svenjoac@gmx.de>
To: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [068/107] Update email address for stable patch submission
References: <20111102221600.GA26650@kroah.com>
	<20111102221456.335891562@clark.kroah.org>
	<1320307257@msgid.manchmal.in-ulm.de>
Date: Thu, 03 Nov 2011 09:25:09 +0100
In-Reply-To: <1320307257@msgid.manchmal.in-ulm.de> (Christoph Biedl's message
	of "Thu, 3 Nov 2011 09:08:18 +0100")
Message-ID: <87k47hd34q.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 03.11.2011 um 09:08 schrieb Christoph Biedl:

> Greg KH wrote...
>
> (...)
>
> Just out of curiosity:
>
>>   - Send the patch, after verifying that it follows the above rules, to
>> -   stable@vger.kernel.org.
>> +   stable@vger.kernel.org.
>>   - The sender will receive an ACK when the patch has been accepted into the
>
>>     other developers and by the relevant subsystem maintainer.
>> - - If the stable@vger.kernel.org address is added to a patch, when it goes into
>> + - If the stable@vger.kernel.org address is added to a patch, when it goes into
>>     Linus's tree it will automatically be emailed to the stable team.
>
> Whatever you used to create the patches, why did these hunks come into
> existence?

The original lines should have had the stable@kernel.org email address,
looks like Greg's scripts eagerly replaced those with the new address…

Cheers,
       Sven
