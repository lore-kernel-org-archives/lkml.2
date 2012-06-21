Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab2FUWWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:22:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53812 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab2FUWWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:22:32 -0400
Date: Fri, 22 Jun 2012 00:22:28 +0200
From: Uros Vampl <mobile.leecher@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Chubb <peter.chubb@nicta.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Aspire One Happy2 reboots only with the kbd method
Message-ID: <20120621222228.GA27593@zverina>
References: <20120621133203.GA26316@zverina>
 <20120621142938.GZ32472@redhat.com>
 <4FE33278.20807@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FE33278.20807@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.06.12 07:40, H. Peter Anvin wrote:
> On 06/21/2012 07:29 AM, Don Zickus wrote:
> > On Thu, Jun 21, 2012 at 03:32:03PM +0200, Uros Vampl wrote:
> >> Add a quirk to make the Acer Aspire One Happy2 reboot properly. For 
> >> reference, discussion at the Arch forums: 
> >> https://bbs.archlinux.org/viewtopic.php?id=143716
> >>
> >> Signed-off-by: Uroš Vampl <mobile.leecher@gmail.com>
> > 
> > Seems fine by me based on the thread above.  Not sure if there is another
> > callback that should be tried first before using BOOT_KBD.  Probably
> > doesn't matter.
> > 
> 
> Actually please do the following:
> 
> a) please use "acpidump" (from the pmtools package) to dump the ACPI
>    tables, specifically the FACP table;
> b) please figure out which of reboot=pci, reboot=kbd, reboot=bios, and
>    reboot=triple work on this platform.
> 
> 	-hpa
> 

I advised the Arch user to join this discussion and provide the 
requested info. I immediately went for kbd as the solution because 
that's exactly what I need for my own Aspire One - that AOA110 quirk 
that's visible in the context of this patch. I figured it's a pattern, 
Aspire One machines quirky in the same way.

Regards,
Uroš
