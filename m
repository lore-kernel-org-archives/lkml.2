Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab2CGMOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:14:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758166Ab2CGMOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:14:09 -0500
Message-ID: <4F575103.50403@redhat.com>
Date: Wed, 07 Mar 2012 09:13:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: EDAC devel <linux-edac@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv7] EDAC core changes in order to properly report errors
 from all types of memory controllers
References: <4F54C133.6040709@redhat.com> <20120305141349.GF1070@aftab> <4F54D4AF.9060802@redhat.com> <4F553764.5070305@redhat.com> <20120305232319.GA7175@aftab> <4F55F598.7050406@redhat.com> <20120306121616.GB11661@aftab> <4F56A9CB.2010504@redhat.com> <20120307084243.GB20727@aftab> <4F57482C.4060105@redhat.com> <20120307120613.GB21202@aftab>
In-Reply-To: <20120307120613.GB21202@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 07-03-2012 09:06, Borislav Petkov escreveu:
> On Wed, Mar 07, 2012 at 08:36:12AM -0300, Mauro Carvalho Chehab wrote:
>>>> - 1 patch that adds a trace event to report memory errors:
>>>>       events/hw_event: Create a Hardware Events Report Mecanism (HERM)
>>>
>>> NACK to that last one.
>>
>> Hmm... interesting... this one adds a tracepoint for non-MCA based memory errors...
>> I've understood that you've against only the mca one...
> 
> If you mean the patch at
> 
> http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commitdiff;h=56efd647f5a63497a07caaa22e993307aaf95270

Yes, that one.

> where you've removed the trace.*mce call, then I don't object to it per
> se. Send it for proper review too, though, because it contains incorrect
> comments like
> 
> + * Those events are generated when hardware detected a corrected or
> + * uncorrected event, and are meant to replace the current API to report
> + * errors defined on both EDAC and MCE subsystems.
> 
> which clearly need fixing.

True. Ok, sent it.
> 
> Thanks.
> 

Thanks,
Mauro
