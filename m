Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1DFHrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 03:47:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab1DFHro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 03:47:44 -0400
Message-ID: <4D9C1AA0.9030008@suse.cz>
Date: Wed, 06 Apr 2011 09:47:44 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH 09/34] x86: Allow to override the ROOT_DEV variable
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz> <1302015561-21047-10-git-send-email-mmarek@suse.cz> <4D9B3581.6080105@zytor.com>
In-Reply-To: <4D9B3581.6080105@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5.4.2011 17:30, H. Peter Anvin wrote:
>> --- a/arch/x86/boot/Makefile
>> +++ b/arch/x86/boot/Makefile
>> @@ -13,7 +13,7 @@
>>  # This can be either FLOPPY, CURRENT, /dev/xxxx or empty, in which case
>>  # the default of FLOPPY is used by 'build'.
>>  
>> -ROOT_DEV	:= CURRENT
>> +ROOT_DEV	?= CURRENT
>>  
>>  # If you want to preset the SVGA mode, uncomment the next line and
>>  # set SVGA_MODE to whatever number you want.
> 
> Is this a good thing?  As far as I understand ?= it may mean picking
> something up from the outside environment.
> 
> Since ROOT_DEV has been obsolete for 15 years or more, this would seem
> to be a needless new error mode.

So can we just set the default root device to (0, 0)?

Michal
