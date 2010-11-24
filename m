Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0KXIyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:54:31 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49198 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab0KXIy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:54:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=O+6ddInExaC4I5YfIQroV60hG8qqD8KybZjNSTX9oh0ms2Ql3I4aQkaebsqFKWXvc+
         0WVF2pb7TfId5/kGkJiU9GWs5wDmBFyJ+PfPN8QDRiSs2+BTXR13E2xNnhn9tFu9fPuG
         AImcWZQuUkWzoX81wzzDwigcLYyE4s+8sPOdI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1290579285.3790.1.camel@jlt3.sipsolutions.net>
References: <AANLkTinVUkgZKbAkQ3_27Jw3cXJ7qySxm1UMFSReujfp@mail.gmail.com>
	<1290579285.3790.1.camel@jlt3.sipsolutions.net>
Date: Wed, 24 Nov 2010 09:54:23 +0100
Message-ID: <AANLkTi=Bf3avTORbP23K7LJfR_T8i5hRm9xVvKGyDRPp@mail.gmail.com>
Subject: Re: linux-next: Tree for November 24 (iwlwifi-fix)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>, sfr@canb.auug.org.au,
        Randy Dunlap <randy.dunlap@oracle.com>,
        John Linville <linville@tuxdriver.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 7:14 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-11-24 at 07:09 +0100, Sedat Dilek wrote:
>
>> Is that fix still required? Fixed in wireless-next-2.6?
>
> That patch was causing that problem, but I fixed the original problem
> since.
>
> johannes
>

Thanks for the quick reply.

I dropped that patch in my series and it looks good now (compile-tested):

$ grep iwl build_linux-next_next20101124.dileks.1.log
  LD      drivers/net/wireless/iwlwifi/built-in.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl3945-base.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-3945.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-3945-rs.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-3945-led.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-rs.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-led.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-ucode.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-tx.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-lib.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-rx.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-calib.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-tt.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-sta.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-eeprom.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-4965.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-rxon.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-hcmd.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-ict.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-5000.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-6000.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-1000.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-core.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-eeprom.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-hcmd.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-power.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-rx.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-tx.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-sta.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-scan.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-led.o
  CC [M]  drivers/net/wireless/iwlwifi/iwl-legacy.o
  LD [M]  drivers/net/wireless/iwlwifi/iwlcore.o
  LD [M]  drivers/net/wireless/iwlwifi/iwlagn.o
  LD [M]  drivers/net/wireless/iwlwifi/iwl3945.o
  CC      drivers/net/wireless/iwlwifi/iwl3945.mod.o
  CC      drivers/net/wireless/iwlwifi/iwlagn.mod.o
  CC      drivers/net/wireless/iwlwifi/iwlcore.mod.o
  LD [M]  drivers/net/wireless/iwlwifi/iwl3945.ko
  LD [M]  drivers/net/wireless/iwlwifi/iwlagn.ko
  LD [M]  drivers/net/wireless/iwlwifi/iwlcore.ko
  INSTALL drivers/net/wireless/iwlwifi/iwl3945.ko
  INSTALL drivers/net/wireless/iwlwifi/iwlagn.ko
  INSTALL drivers/net/wireless/iwlwifi/iwlcore.ko

- Sedat -
