Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab0GMQq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 12:46:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab0GMQq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 12:46:26 -0400
Message-ID: <4C3C9839.4090404@redhat.com>
Date: Tue, 13 Jul 2010 19:45:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Peter Palfrader <peter@palfrader.org>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization	point
 for pvclock
References: <20100701175144.GA2116@kroah.com> <20100701173218.125822294@clark.site> <20100707124731.GJ15122@anguilla.noreply.org> <4C359D5A.1050906@redhat.com> <20100713102350.GW15122@anguilla.noreply.org> <4C3C68C8.4060409@redhat.com> <20100713141902.GB15122@anguilla.noreply.org> <4C3C8CE5.1080705@redhat.com> <20100713162207.GC15122@anguilla.noreply.org> <4C3C9589.4090602@redhat.com> <4C3C96EC.8060901@redhat.com>
In-Reply-To: <4C3C96EC.8060901@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 07:40 PM, Avi Kivity wrote:
> On 07/13/2010 07:34 PM, Avi Kivity wrote:
>>
>> My bet is that dropping 'static' will fix it.  We may have the wrong 
>> constraints on atomic64_cmpxchg64(), so the compiler thinks we never 
>> change last_value.
>>
>
> The constraints are there, but maybe the toolchain is confused.
>

No they aren't, as Linus just pointed out.  His patch should fix the 
problem.

-- 
error compiling committee.c: too many arguments to function

