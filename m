Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1LSXQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:16:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48991 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab1LSXQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:16:43 -0500
Message-ID: <4EEFC5C5.1000306@zytor.com>
Date: Mon, 19 Dec 2011 15:16:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, trenn@suse.de, kay.sievers@vrf.org,
        kay.sievers@vrfy.org
Subject: Re: [PATCH 08/10] cpufreq: Add support for x86 cpuinfo auto loading
References: <1324334865-30459-1-git-send-email-andi@firstfloor.org> <1324334865-30459-9-git-send-email-andi@firstfloor.org> <20111219230341.GA570@redhat.com> <20111219231222.GA31168@tassilo.jf.intel.com>
In-Reply-To: <20111219231222.GA31168@tassilo.jf.intel.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 03:12 PM, Andi Kleen wrote:
>> Looking closer at this one, I think we could possibly just autoload based on the PCI IDs
>> in gx_chipset_tbl, and remove the cpu vendor checking entirely.
>> Pretty sure those Cyrix PCI devices won't show up anywhere else.
> 
> Ok. Will do that.
>  

I'll drop this subpatch then... the PCI device one should be orthogonal.

	-hpa
