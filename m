Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1G0P6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:58:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab1G0P6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:58:17 -0400
Message-ID: <4E303579.4000903@redhat.com>
Date: Wed, 27 Jul 2011 18:57:45 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, "Przywara, Andre" <Andre.Przywara@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
References: <4E2F0498.8050005@zytor.com> <20110726183721.GF32536@aftab> <4E2F09BB.9060605@zytor.com> <4E2F1889.8030708@amd.com> <4E2F90A2.4030409@redhat.com> <20110727062120.GA5272@aftab> <20110727065932.GA16555@elte.hu> <4E2FDAD0.8000809@redhat.com> <20110727153731.GA19477@aftab> <4E30327C.5020509@redhat.com> <20110727154957.GB19477@aftab>
In-Reply-To: <20110727154957.GB19477@aftab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 06:49 PM, Borislav Petkov wrote:
> On Wed, Jul 27, 2011 at 11:45:00AM -0400, Avi Kivity wrote:
> >  What about F21h processors?  I see you're not checking them.
> >
> >  Is there any reason the check should not be made based on topology?
>
> Because this patch addresses a performance improvement for the F15h
> microarchitecture - that doesn't have anything to do with cache
> topology.

Okay.

Out of curiosity, what's the performance impact if the workaround is not 
enabled?

-- 
error compiling committee.c: too many arguments to function

