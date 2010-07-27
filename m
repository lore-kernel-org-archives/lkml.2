Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab0G0Rxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:53:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39321 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab0G0Rxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:53:40 -0400
Message-ID: <4C4F1CE4.70605@zytor.com>
Date: Tue, 27 Jul 2010 10:52:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Palfrader <peter@palfrader.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point
 	for pvclock
References: <20100701175144.GA2116@kroah.com>	<20100701173218.125822294@clark.site>	<20100707124731.GJ15122@anguilla.noreply.org>	<4C359D5A.1050906@redhat.com>	<20100713102350.GW15122@anguilla.noreply.org>	<4C3C68C8.4060409@redhat.com>	<20100713141902.GB15122@anguilla.noreply.org>	<4C3C8CE5.1080705@redhat.com>	<AANLkTim_xKrPSTNqS3JWipjlAkmeDnlEYcHt1cn90ggB@mail.gmail.com>	<4C3CAAC6.501@redhat.com> <AANLkTik_hRn9acIuuRBJDWLuQVUh9qE-blvgFmUQvzlz@mail.gmail.com> <4C4F1B6D.1070207@goop.org>
In-Reply-To: <4C4F1B6D.1070207@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 10:46 AM, Jeremy Fitzhardinge wrote:
>  On 07/13/2010 11:15 AM, Linus Torvalds wrote:
>> On Tue, Jul 13, 2010 at 11:04 AM, Avi Kivity<avi@redhat.com>  wrote:
>>> Well, current upstream uses "m":
>> Yes, I'd expect current 2.6.34 to also show the same problem.
>>
>>> and works; I also failed to reproduce with 2.6.32.16.  So I expect some
>>> toolchain involvement.
>> And yes, I do believe it's likely a newer gcc that triggers it too,
>> otherwise we'd have seen more reports of it.
> 
> Did anyone get around to doing a proper fix for this?   I don't see one
> in tip.git or linux-2.6.git.  And it needs to get back into stable...
> 

I'll go ahead and write it up.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

