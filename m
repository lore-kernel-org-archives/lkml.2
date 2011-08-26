Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1HZBnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 21:43:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35036 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab1HZBnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 21:43:08 -0400
Message-ID: <4E56F9E5.4000005@zytor.com>
Date: Thu, 25 Aug 2011 18:41:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Ralf Jung <ralfjung-e@gmx.de>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com> <1314315225.16133.30.camel@sbsiddha-desk.sc.intel.com> <CAErSpo7N3UBJgQTb+zePnsf5YuFSQT8zy9CftwceyAKKfcHUjA@mail.gmail.com>
In-Reply-To: <CAErSpo7N3UBJgQTb+zePnsf5YuFSQT8zy9CftwceyAKKfcHUjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2011 05:17 PM, Bjorn Helgaas wrote:
> 
> If the OS allocated the next 128 bytes to another device, it sounds
> like it would cause a conflict on Intel boxes.  This must be an area
> that differs between vendors.  I haven't seen a spec that mentions 256
> bytes as the required minimum MMIO size for IOAPICs, and apparently
> the AMD IOAPIC decodes 240 bytes or fewer.
> 

For what it's worth, it's probably a bad idea on x86 for the OS to
allocate addresses in the 0xFExxxxxx range...

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

