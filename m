Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2EJNQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 09:16:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340Ab2EJNQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 09:16:47 -0400
Message-ID: <4FABBFAF.20809@redhat.com>
Date: Thu, 10 May 2012 10:16:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [EDAC ABI v13 04/25] events/hw_event: Create a Hardware Events
 Report Mecanism (HERM)
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com> <1334608729-30803-5-git-send-email-mchehab@redhat.com> <20120509121326.GA22737@aftab.osrc.amd.com> <4FAA6802.9070506@redhat.com> <20120509132237.GD22737@aftab.osrc.amd.com> <4FAA7649.5080606@redhat.com> <20120509140632.GG22737@aftab.osrc.amd.com> <4FAA7C1A.3020406@redhat.com> <20120509142456.GH22737@aftab.osrc.amd.com>
In-Reply-To: <20120509142456.GH22737@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 09-05-2012 11:24, Borislav Petkov escreveu:
> On Wed, May 09, 2012 at 11:15:54AM -0300, Mauro Carvalho Chehab wrote:
>> Em 09-05-2012 11:06, Borislav Petkov escreveu:
>>> On Wed, May 09, 2012 at 10:51:05AM -0300, Mauro Carvalho Chehab wrote:
>>>>> Now, if you really want to have a generic mechanism for RAS, used
>>>>> by all the kernel, then I don't have a problem with you adding it
>>>>> to include/ras/hw_event.h or somewhere in that vicinity along with
>>>>> making it generic enough for other users and then taking care of it and
>>>>> developing it to address users' needs.
>>>>
>>>> I'm ok to move it to include/ras, but, if I remember well from my initial
>>>> tests when I wrote this, several kernel versions ago, there is/was
>>>> a limitation that required that all trace events should be under
>>>> include/trace/events/.
>>>>
>>>> One other option would be to call it as "include/trace/events/ras.h".
>>>>
>>>> Steven,
>>>>
>>>> Would it be possible/recommendable to move this trace header
>>>> to include/linux/ras/hw_event.h?
>>>
>>> Oh, yeah, I remember vaguely something like that. Lets wait what Steven
>>> has to say.
> 
> btw, http://lwn.net/Articles/383362/ explains how to define tracepoints outside
> of include/trace/events.
> 
> [ … ]
> 
>>> and above says "Hardware Events Report Method (HERM)" The fact that you
>>> yourself are not exactly sure about what this abbreviation is supposed
>>> to be/mean/etc, simply should tell you that it is causing only confusion
>>> with no benefit what-so-ever, even to you!
>>
>> Fixed.
> 
> No, you haven't. It still says HERM below. Please drop the marketing speak!

Nah, this is not marketing speak. HERM is not a trademark. amd64_edac, on the other
hand, is using a trademark on his name. If we use your logic, this would need to
be renamed to something else, to avoid using a "marketing speak".

We need some name to differentiate between the broken EDAC core where modern
memory controllers are not properly represented and reports errors on 
fake csrows/channels from the EDAC+HERM core that will properly provide the
error information to where it really belongs.

In other words, HERM is just an acronym[1] to the version to point to where 
EDAC starts to work fine with modern memory controllers.

[1] Btw, EDAC is also an acronym for Error Detection And Correction.

Regards,
Mauro
