Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331Ab2EJOxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:53:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757103Ab2EJOxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:53:25 -0400
Message-ID: <4FABD653.7060401@redhat.com>
Date: Thu, 10 May 2012 11:53:07 -0300
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
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com> <1334608729-30803-5-git-send-email-mchehab@redhat.com> <20120509121326.GA22737@aftab.osrc.amd.com> <4FAA6802.9070506@redhat.com> <20120509132237.GD22737@aftab.osrc.amd.com> <4FAA7649.5080606@redhat.com> <20120509140632.GG22737@aftab.osrc.amd.com> <4FAA7C1A.3020406@redhat.com> <20120509142456.GH22737@aftab.osrc.amd.com> <4FABBFAF.20809@redhat.com> <20120510134136.GC31257@aftab.osrc.amd.com>
In-Reply-To: <20120510134136.GC31257@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 10-05-2012 10:41, Borislav Petkov escreveu:
> On Thu, May 10, 2012 at 10:16:31AM -0300, Mauro Carvalho Chehab wrote:
>> Nah, this is not marketing speak. HERM is not a trademark. amd64_edac,
>> on the other hand, is using a trademark on his name. If we use your
>> logic, this would need to be renamed to something else, to avoid using
>> a "marketing speak".
> 
> I'm not even going to dignify that with an answer because it is a bunch
> of bullshit and you know it.
> 
>> We need some name to differentiate between the broken EDAC core where
>> modern memory controllers are not properly represented and reports
>> errors on fake csrows/channels from the EDAC+HERM core that will
>> properly provide the error information to where it really belongs.
> 
> A kernel version or a commit id is not enough here I guess.
> 
>> In other words, HERM is just an acronym[1] to the version to point to
>> where EDAC starts to work fine with modern memory controllers.
> 
> Seems to me you're desperately trying to prove your point for having
> this HERM thing by coming up with a bunch of bogus arguments.
> 
> And I'm still waiting for a real, technical reason which legitimizes
> calling a tracepoint something special.

Technical reasons were provided already: before this patch series, EDAC
is *broken*.

Mauro.
