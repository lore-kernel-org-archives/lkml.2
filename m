Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0GMP5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 11:57:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756866Ab0GMP5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 11:57:54 -0400
Message-ID: <4C3C8CE5.1080705@redhat.com>
Date: Tue, 13 Jul 2010 18:57:25 +0300
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
References: <20100701175144.GA2116@kroah.com> <20100701173218.125822294@clark.site> <20100707124731.GJ15122@anguilla.noreply.org> <4C359D5A.1050906@redhat.com> <20100713102350.GW15122@anguilla.noreply.org> <4C3C68C8.4060409@redhat.com> <20100713141902.GB15122@anguilla.noreply.org>
In-Reply-To: <20100713141902.GB15122@anguilla.noreply.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 05:19 PM, Peter Palfrader wrote:
>
>> So it looks like last_value was placed in a read only section.  Please
>> post your System.map somewhere.
>>      
> weasel@intrepid:~$ publish System.map
> http://asteria.noreply.org/~weasel/volatile/2010-07-13-mbm2xEdd8Q4/System.map
> weasel@intrepid:~$ grep -i last_value System.map
> ffffffff81712e80 r last_value
> ffffffff81b05240 b last_value.26163
>    

"r" = "read only"

How does it look in 'nm arch/x86/kernel/pvclock.o'?
