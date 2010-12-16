Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab0LPQx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:53:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55740 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab0LPQxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:53:53 -0500
Message-ID: <4D0A43FD.3070509@zytor.com>
Date: Thu, 16 Dec 2010 08:53:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <20101216100050.GA2261@redhat.com> <4D0A3B69.6080700@zytor.com> <20101216162255.GE13870@redhat.com>
In-Reply-To: <20101216162255.GE13870@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2010 08:22 AM, Vivek Goyal wrote:
>>
>> I think limiting kdump below 512 MiB on 32 bits may make sense; perhaps
>> even on 64 bits.  It's pretty conservative, after all...
>>
>> Opinions?
> 
> Actually it will be good to know why 512MB. I know in the past we have
> been talking of reserving memory in higher memory regions and Neil Horman
> had been trying to boot bzImage in 64 bit mode so that it can be run
> from higher addresses. 
> 
> So right now limiting it is easy but it is desirable to be able to run
> bzImage from as high a address as possible and knowing why to limit it
> to 512MB can help see if there is a way to get rid of that limitation.
> 
> I probably would not worry about 32bit systems but for 64 bit, I
> cerntainly want to make it boot from higher addresses (if it is possible
> technically).
> 

It's worth noting that there is almost always going to be a need for
*some* low memory.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

