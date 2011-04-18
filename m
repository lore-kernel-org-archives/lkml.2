Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab1DRPxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:53:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43735 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029Ab1DRPxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:53:37 -0400
Message-ID: <4DAC5E70.6040204@zytor.com>
Date: Mon, 18 Apr 2011 08:53:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110403 Fedora/3.1.9-6.fc15 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 4/4] x86, gart: Make sure GART does not map physmem above
 1TB
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com> <1303134346-5805-5-git-send-email-joerg.roedel@amd.com> <4DAC4EC0.80008@zytor.com> <20110418145230.GH2192@amd.com>
In-Reply-To: <20110418145230.GH2192@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 07:52 AM, Roedel, Joerg wrote:
>>
>> Where does this limit come from?
> 
> From the hardware. A GART PTE is only 32 bits in size so that it cannot
> be expanded. The physical address bits 32-39 are mapped 11:4 in the PTE.
> This can not be architecturally expanded to more than 40 physical bits.
> 

AFAIK the GART format is implementation-specific (unless some standard
crept up when I wasn't looking -- this happens from time to time); this
file seems, despite its generic name, to be AMD K8 specific.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

