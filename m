Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab1KUP5E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:57:04 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60916 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1KUP5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:57:00 -0500
References: <B458B2F0-2DDA-461F-A125-8C6C4CDEB6C5@gmail.com> <20111118222718.GF22904@local> <C27E2EE4-3534-4FC2-997A-0F090BF2AAF5@gmail.com> <8be4650484e8827410219db85531ecaf.squirrel@webmail.sf-mail.de>
In-Reply-To: <8be4650484e8827410219db85531ecaf.squirrel@webmail.sf-mail.de>
Mime-Version: 1.0 (Apple Message framework v1084)
X-Priority: 3 (Normal)
Content-Type: text/plain; charset=us-ascii
Message-Id: <A8A9A42D-B960-4188-9C81-83FB25E1106D@gmail.com>
Content-Transfer-Encoding: 8BIT
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Greg KH <gregkh@suse.de>,
        tglx@linutronix.de, linux-pci@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Simon Goyette <goyettes@sonatest.com>
From: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Subject: Re: extra large DMA buffer for PCI-E device under UIO
Date: Mon, 21 Nov 2011 11:01:01 -0500
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 21, 2011, at 10:47, Rolf Eike Beer wrote:

>> The pci ID we use is not registered, and except for this driver, which
>> is a non-driver really (UIO), the FPGA firmware and the userspace code is
>> proprietary.
> 
> Why keep people doing this? This is just asking for future trouble. And it
> gives bad karma.
This is a bit off topic...

Still, to address it:
... because when developing a complex product with limited staff, you prioritize.

Unless I am mistaken, my use of PCI ids is to match our HW device with our
driver (which is yet not meant to be merged to mainline) in our completely controlled
system (hw, kernel, software) made into a product. So we didn't feel it necessary
to assign guaranteed unique IDs. If there are any ID conflicts one day, I assume
it would be because of a new kernel version we put in, or a new hardware
device we put in and in any case, a new release of the product which is 
thoroughly tested before released. Furthermore, in the unlikely event we do
encounter a collision, we can change both the FPGA and the driver on a dime.

Am I missing something? What kind of future trouble are you referring to?
> 
> Go and ask your FPGA vendor to assign a device id to you. At least for
> Xilinx this has worked.
Thanks for the tip, we could look into this if we need to.
> 
> Eike

