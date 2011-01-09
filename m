Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1AIMyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 07:54:54 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:50921 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab1AIMyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 07:54:53 -0500
X-Authority-Analysis: v=1.1 cv=uESSSoDEku2quKX/oFXS2Smn5+55LTFcWFr5T5T8nFs= c=1 sm=0 a=8nJEP1OIZ-IA:10 a=uMtljfmLDVLoqQOk5K3MRw==:17 a=tBb2bbeoAAAA:8 a=IyxiOcA9AAAA:8 a=YuHknOXIayWndvN2_T8A:9 a=WVmArTtOvVSbcyId_khzh6dZuWsA:4 a=wPNLvfGTeEIA:10 a=YuKU6ANggZ8A:10 a=oRKvI3aUKtQ-dFsz:21 a=ooRbV1yxMMBimkzn:21 a=uMtljfmLDVLoqQOk5K3MRw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 68.204.193.27
Message-ID: <4D29B01A.6020807@cfl.rr.com>
Date: Sun, 09 Jan 2011 07:54:50 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "Artem S. Tashkinov" <t.artem@lycos.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org,
        Claudio Scordino <claudio@evidence.eu.com>
Subject: Re: On Linux numbering scheme
References: <AANLkTik_pa7ac4iQAyU7JeUej7qfkAvYQTru7n0-mZAt@mail.gmail.com> <32869803.14581294498166043.JavaMail.root@mail-zbox20.bo3.lycos.com> <20110108161156.GB16090@suse.de>
In-Reply-To: <20110108161156.GB16090@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2011 11:11 AM, Greg KH wrote:
> On Sat, Jan 08, 2011 at 09:49:26AM -0500, Artem S. Tashkinov wrote:
>> ----- "Geert Uytterhoeven" <geert@linux-m68k.org> wrote:
>>
>>> On Thu, Jan 6, 2011 at 09:31, Claudio Scordino
>>> <claudio@evidence.eu.com> wrote:
>>>>>   As time passes by, the Linux numbering scheme makes even less
>>> sense.
>>>>>   Some time ago there was a discussion on LKML about a new
>>> numbering
>>>>>   scheme but it didn't come to any positive conclusion and then
>>> the
>>>>>   subject was forgotten entirely. Not meaning to raise a clamour
>>> here
>>>>>   (and I suppose I represent a large group of Linux users here).
>>> I'm
>>>>>   willing to suggest a numbering scheme which I hope will answer
>>> all
>>>>>   known complaints and criticism.
>>>>
>>>> This seems to be a periodically recurrent topic on the list.
>>>>
>>>> If I've correctly understood all points of view, there are currently
>>> two
>>>> groups of developers:
>>>>
>>>> 1. Those who want to maintain the current numbering scheme, because
>>> they
>>>> feel comfortable with it, and because they can easily understand
>>> the
>>>> number of releases between one release and another.
>>>>
>>>> 2. Those who prefer having a scheme somehow related to the date, so
>>> they
>>>> can easily understand when a certain kernel has been released (i.e.
>>> how
>>>> "old" it is).
>>>>
>>>> Does really exist a numbering scheme that can satisfy both groups
>>> of
>>>> people ? Probably not.
>>>>
>>>> My only idea would be to maintain the usual numbering scheme, and
>>> just
>>>> replace the second number (6) with the year of release.
>>>>
>>>> For example:
>>>>
>>>>        2.6.36 would be 2.10.36
>>>>
>>>>        2.6.37 would be 2.11.37
>>>>
>>>>        2.6.38 would be 2.11.38
>>>>
>>>>        and so on...
>>>>
>>>> This way, you put some information about the year of release
>>> without
>>>> loosing all the benefits of the current scheme.
>>>>
>>>> But this means having two independent incremental numbers, which
>>> maybe
>>>> is a too insane scheme.
>>>
>>> Then why not drop the leading "2." completely?
>>>
>>
>> This will break too many user space scripts/applications which expect
>> 2.x.x.x numbers.
> 
> What userspace scripts/applications expect numbers like that?  How do
> they handle releases like what Linus just did (2.6.37)?
> 

I've often wondered why that case wouldn't be done as 2.6.37.0 ???

Mark
