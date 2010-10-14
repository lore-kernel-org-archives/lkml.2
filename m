Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab0JNRpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 13:45:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58024 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010Ab0JNRpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 13:45:07 -0400
Message-ID: <4CB7418C.7010505@zytor.com>
Date: Thu, 14 Oct 2010 10:44:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
References: <alpine.DEB.2.00.1010131713160.24646@chino.kir.corp.google.com>	<4CB64D8F.9080800@zytor.com>	<alpine.DEB.2.00.1010131739010.27124@chino.kir.corp.google.com>	<4CB65262.3070507@zytor.com>	<alpine.DEB.2.00.1010131744540.27124@chino.kir.corp.google.com>	<cbd8b37e-a1a3-4275-8acb-a76476211366@email.android.com>	<alpine.DEB.2.00.1010131832400.794@chino.kir.corp.google.com>	<4CB688F4.9040706@zytor.com>	<alpine.DEB.2.00.1010132140550.20995@chino.kir.corp.google.com>	<4CB7240E.9000905@zytor.com> <AANLkTin-VOKXe6wcwt_r3bLcS6=WYJ4EAPPUZWLbEGQF@mail.gmail.com>
In-Reply-To: <AANLkTin-VOKXe6wcwt_r3bLcS6=WYJ4EAPPUZWLbEGQF@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2010 09:00 AM, Pekka Enberg wrote:
> On 10/13/2010 09:46 PM, David Rientjes wrote:
>>> I'm not running a CONFIG_EMBEDDED kernel and I'm pretty sure Casey isn't
>>> either, so we'd still need to carry our own patches to change the Kconfig
>>> bool line anyway.
>>>
>>> I'm suprised that we can't allow users who definitively know that they
>>> have no hardware limitations the ability to disable ZONE_DMA.  Would a
>>> strong caution in the Kconfig "help" text suffice or will you not be
>>> convinced?
> 
> On Thu, Oct 14, 2010 at 6:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> CONFIG_EMBEDDED *is* "I am a user who (think I) know what I'm doing".
>> That is *what it is* and *all it is*.
> 
> Yup. The naming is quite unfortunate, though. Can we change it to
> something else?
> 

Funny, this seems to come up repeatedly ;)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

