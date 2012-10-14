Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab2JNQJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 12:09:04 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:24491 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab2JNQJC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 12:09:02 -0400
X-Authority-Analysis: v=2.0 cv=Dp3UCRD+ c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=h9GbcFHyNoYA:10 a=g7R6esmICIkA:10 a=05ChyHeVI94A:10 a=8nJEP1OIZ-IA:10 a=ayC55rCoAAAA:8 a=HjRi3UqH30YA:10 a=5RYEUZYjsNXXIOxhqXIA:9 a=wPNLvfGTeEIA:10 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <507AE39D.5020708@cfl.rr.com>
Date: Sun, 14 Oct 2012 12:09:01 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: Daniel Vetter <daniel@ffwll.ch>, markh@compro.net,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] Intel graphics drm issue?
References: <507812E8.3060607@compro.net> <20121012231459.166e29fd@neptune.home> <5079B97C.7020401@cfl.rr.com> <5079BE5C.8020401@cfl.rr.com> <CAKMK7uGXb5=fHXZa8m_0xNLGFqyf_b37g9W32eshaPFcf8i=7A@mail.gmail.com> <507A91EA.2030205@cfl.rr.com> <CAKMK7uEw8D1r4hf_mE1q6kBwZzE+qmSeTui9adX4agj=5MDbWw@mail.gmail.com> <507AC9DC.4030701@cfl.rr.com> <CAKMK7uERj4+QtxMzzHsbxbqvUYNGWxmieZeebS3+CjAbj6Kq1g@mail.gmail.com> <507ADD14.7050503@cfl.rr.com> <CAKMK7uGCyHaXko102_VDus3RCarDobeiRcNKnzjqX3YFK2ouBw@mail.gmail.com> <20121014175538.3bdd7cb8@neptune.home>
In-Reply-To: <20121014175538.3bdd7cb8@neptune.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2012 11:55 AM, Bruno Prémont wrote:
> On Sun, 14 October 2012 Daniel Vetter <daniel@ffwll.ch> wrote:
>> On Sun, Oct 14, 2012 at 5:41 PM, Mark Hounschell <dmarkh@cfl.rr.com> wrote:
>>> There is something amiss. Here is my  i915_pci_probe routine. I Added a
>>> couple more printks. NONE of these show up in dmesg. Not even the "Entered"
>>> printk. ????
>>
>> That's rather strange indeed. Is there another driver bound by
>> accident to the intel graphics? You can check that with lspci -k
>> -Daniel
>
> A few mails ago in a kernel cmd I saw a nomodeset, could it be that
> it's still around?

Yes, that is still around. I'll get rid of it and try again.

Mark


