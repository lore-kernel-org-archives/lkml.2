Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab0IONUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:20:46 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:40264 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab0IONUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:20:45 -0400
Message-ID: <4C90C829.2080005@xs4all.nl>
Date: Wed, 15 Sep 2010 15:20:41 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Fwd: patch: HPET force enable for CX700 / VIA Epia LT  was: Re: hpet
 timers gone?
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Who can help me get this minor patch into the kernel?

Kind regards,
Udo

-------- Original Message --------
Subject: patch: HPET force enable for CX700 / VIA Epia LT  was: Re: hpet
timers gone?
Date: Tue, 14 Sep 2010 07:15:08 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
To: Robert Hancock <hancockrwd@gmail.com>
CC: linux-kernel@vger.kernel.org

On 2010-09-14 01:16, Robert Hancock wrote:
> On Mon, Sep 13, 2010 at 8:52 AM, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
>> So what else can I do to enable HPET?
> 
> At this point, not much, unless you can track down the chipset
> information that would allow us to implement force enabling HPET on
> that chipset..

Signed-off-by: Udo van den Heuvel <udovdh@xs4all.nl>

--- a/arch/x86/kernel/quirks.c	2010-09-13 18:02:14.639710309 +0200
+++ b/arch/x86/kernel/quirks.c	2010-09-13 18:02:06.095280815 +0200
@@ -344,6 +344,8 @@
 			 vt8237_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8237,
 			 vt8237_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_CX700,
+			 vt8237_force_enable_hpet);

 static void ati_force_hpet_resume(void)
 {

Patch does make hpet appear on VIA Epia LT (CX700M2 chipset) with
hpet=force on kernel commandline.


Udo

