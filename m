Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822Ab1LPBUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 20:20:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44716 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385Ab1LPBUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 20:20:17 -0500
Message-ID: <4EEA9CB2.9020709@zytor.com>
Date: Thu, 15 Dec 2011 17:19:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Borislav Petkov <bp@amd64.org>, linux-kernel@vger.kernel.org,
        kay.sievers@vrfy.org, trenn@suse.de, Andi Kleen <ak@linux.intel.com>,
        davej@redhat.com
Subject: Re: [PATCH 07/10] cpufreq: Add support for x86 cpuinfo auto loading
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org> <1323304882-27953-8-git-send-email-andi@firstfloor.org> <20111208084958.GA23245@gere.osrc.amd.com> <20111208143725.GD24062@one.firstfloor.org>
In-Reply-To: <20111208143725.GD24062@one.firstfloor.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2011 06:37 AM, Andi Kleen wrote:
>> Well, there is CPUID_8000_0007_EDX[7] which denotes the presence
>> of the P-state registers. It probably could be added to
>> init_scattered_cpuid_features() but there's still special handling
>> needed for K8.
> 
> Dave is probably right that it's not worth moving the list.
> 
>> Can you do both a family and a feature bit test with the autoprobing
>> code?
> 

Another similar question: is it possible to key a load on more than one
CPU feature?  It's fairly common that you need more than one feature for
a specific piece of code to function, and it would be good to be able to
represent it.

	-hpa


