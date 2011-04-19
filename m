Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab1DSNoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:44:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52330 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab1DSNoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:44:23 -0400
Message-ID: <4DAD919A.3080102@kernel.org>
Date: Tue, 19 Apr 2011 06:43:54 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Roedel, Joerg" <Joerg.Roedel@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 4/4] x86, gart: Make sure GART does not map physmem above
 1TB
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com> <1303134346-5805-5-git-send-email-joerg.roedel@amd.com> <4DAC4EC0.80008@zytor.com> <4DAC5099.4010403@kernel.org> <20110418145941.GJ2192@amd.com> <20110418155033.GC8623@elte.hu> <20110419061259.GL2192@amd.com> <20110419072520.GD25353@elte.hu>
In-Reply-To: <20110419072520.GD25353@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2011 12:25 AM, Ingo Molnar wrote:
>>>>
>>>> Yes, this file mostly contains the dma-ops implementation that uses the
>>>> K8 gart plus some k8-gart specific initialization functions.
>>>
>>> Does the file want to be renamed to pci-amd_gart_64.c or so?
>>
>> Hmm, that seems long. How about just amd64_gart.c?
> 

Arguably we call this the k8_nb in other places, so my suggestion would
be k8_gart.c

	-hpa
