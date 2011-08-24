Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1HXWiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:38:25 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:49599 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab1HXWiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:38:24 -0400
Date: Wed, 24 Aug 2011 18:38:14 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/4] x86: base support for the TS-5500 platform
Message-ID: <20110824183814.64abc94c@v0nbox>
In-Reply-To: <4E5576CF.2050905@zytor.com>
References: <1314217407-31249-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1314217407-31249-2-git-send-email-vivien.didelot@savoirfairelinux.com>
	<4E55670F.90102@zytor.com>
	<20110824180837.6841f3d8@v0nbox>
	<4E5576CF.2050905@zytor.com>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011 15:10:23 -0700,
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 08/24/2011 03:08 PM, Vivien Didelot wrote:
> > Indeed this will be run on any Elan SC520 based platforms if the
> > user has asked for TS-5500 support in the menuconfig. I could add
> > checks for other hardware such as the Ethernet controller, but it
> > would require including pci headers and delaying the initcall
> > (using late_initcall instead of postcore_initcall).
> > That's why I think it is not really worth adding more tests. They
> > could be added later in this function if there is really a need.
> > 
> > Regards,
> > Vivien.
> 
> Hello?  HELLO?
> 
> We do not break unrelated hardware just because something is enabled
> at compile time.
> 
> EVER.
> 
> 	-hpa

I agree with you. The platform does not provide many identification
points. We have specific hardware such as the CPU, Ethernet, Cardbus
and USB controllers; there is no DMI available; no PCI bridge subvendor
info, only the BIOS provides a 16-bit identification call...
We discussed that point in https://lkml.org/lkml/2011/5/4/437 without
success.

What would be the proper way in your opinion?

Vivien.
