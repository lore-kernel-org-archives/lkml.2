Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001Ab2FUOle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 10:41:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50013 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab2FUOlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 10:41:32 -0400
Message-ID: <4FE33278.20807@zytor.com>
Date: Thu, 21 Jun 2012 07:40:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Uros Vampl <mobile.leecher@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Chubb <peter.chubb@nicta.com.au>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH] x86: Aspire One Happy2 reboots only with the kbd method
References: <20120621133203.GA26316@zverina> <20120621142938.GZ32472@redhat.com>
In-Reply-To: <20120621142938.GZ32472@redhat.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 07:29 AM, Don Zickus wrote:
> On Thu, Jun 21, 2012 at 03:32:03PM +0200, Uros Vampl wrote:
>> Add a quirk to make the Acer Aspire One Happy2 reboot properly. For 
>> reference, discussion at the Arch forums: 
>> https://bbs.archlinux.org/viewtopic.php?id=143716
>>
>> Signed-off-by: Uroš Vampl <mobile.leecher@gmail.com>
> 
> Seems fine by me based on the thread above.  Not sure if there is another
> callback that should be tried first before using BOOT_KBD.  Probably
> doesn't matter.
> 

Actually please do the following:

a) please use "acpidump" (from the pmtools package) to dump the ACPI
   tables, specifically the FACP table;
b) please figure out which of reboot=pci, reboot=kbd, reboot=bios, and
   reboot=triple work on this platform.

	-hpa

