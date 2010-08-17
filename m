Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab0HQQtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 12:49:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48292 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab0HQQtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 12:49:46 -0400
Message-ID: <4C6ABDA4.2030409@zytor.com>
Date: Tue, 17 Aug 2010 09:49:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: akataria@vmware.com
CC: the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Skip cpu_calibrate for kernel running	under	hypervisors.
References: <1281986754.23253.32.camel@ank32.eng.vmware.com>	 <4C69D02F.6090601@zytor.com>	 <1282024311.20786.2.camel@ank32.eng.vmware.com>	 <4C6A2C98.4060605@zytor.com> <1282063710.4388.11.camel@ank32.eng.vmware.com>
In-Reply-To: <1282063710.4388.11.camel@ank32.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2010 09:48 AM, Alok Kataria wrote:
>
> I am planning to add a calibrate_apic function ptr in x86_platform_ops,
> for getting the APIC frequency too directly from the hypervisor. If you
> want I can add this calibrate_cpu function ptr too or is the patch below
> okay for now ?
>

That would be good.

	-hpa
