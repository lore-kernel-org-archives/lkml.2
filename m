Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab0EYD1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 23:27:13 -0400
Received: from crca.org.au ([74.207.252.120]:51955 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757993Ab0EYD1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 23:27:12 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BFB438A.8000909@crca.org.au>
Date: Tue, 25 May 2010 13:27:06 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Matthew Garrett <mjg@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
       linux-next@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [PATCH -next] nouveau: fix acpi_lid_open undefined
References: <20100522170459.4c89723d.sfr@canb.auug.org.au>	 <20100523170040.3c4aa87c.randy.dunlap@oracle.com>	 <20100524125628.GA14278@srcf.ucam.org> <4BFA84EF.7070609@oracle.com>	 <20100524135940.GA15892@srcf.ucam.org>  <4BFA8A71.4080900@oracle.com> <1274741255.3416.1.camel@clockmaker-el6>
In-Reply-To: <1274741255.3416.1.camel@clockmaker-el6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 25/05/10 08:47, Dave Airlie wrote:
> On Mon, 2010-05-24 at 07:17 -0700, Randy Dunlap wrote:
>> On 05/24/10 06:59, Matthew Garrett wrote:
>>> On Mon, May 24, 2010 at 06:53:51AM -0700, Randy Dunlap wrote:
>>>> On 05/24/10 05:56, Matthew Garrett wrote:
>>>>> Won't this result in a behavioural difference? The desirable outcome is
>>>>
>>>> It could, yes.
>>>>
>>>>> that that configuration be impossible, not for that configuration to
>>>>> build but be buggy.
>>>>
>>>> so nouveau should depend on (or select, if ACPI is enabled) ACPI_BUTTON?
>>>
>>> There's an argument that it doesn't need to depend on it, but if button
>>> is a module then nouveau has to be. Except the inverse isn't true.
>>> Kconfig is hard, let's weep gently.
>>
>> Maybe Dave can weep with us when he is back at work...
>
> Yeah I've had problems like this a few times lately with the drm, I'm
> torn between just adding select all over the place, or assuming someone
> sane is configuring the kernel.
>
> I'm sort of erring on the someone sane is configuring the kernel just
> because Linus's objects to "default y" things seems to point at that we
> can't really give pointers to the people who haven't done it before. So
> I'm quite happy to leave it having different behaviour depending on the
> configuration and simply ignoring bug reports from incompetents.

'scuse me for butting in, but would you at least consider adding 
something to the help for the Nouveau and/or ACPI button options? You 
might have a sane person configuring the kernel, but that doesn't mean a 
dependency like this would necessarily be obvious to them.

Personally, I'd argue for the select.

Regards,

Nigel
