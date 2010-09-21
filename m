Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0IUNdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 09:33:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47626 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254Ab0IUNc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 09:32:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hupQ73RbOII9CpTG0NlCbuKXZiWmauN8MqQnnhnphJI5bvF6UbT6UqNYs7lUTBbhQ8
         n4QbPM6lbjQqUXQPTsEguuBEoI3GHgyoOmepFQa85p5i1f7q5QtyUaApnt995axVKbgD
         TbiML1CTbx3feJnorX1m2/h7+bu4YOxzCT8V4=
Message-ID: <4C98B40A.2080302@gmail.com>
Date: Tue, 21 Sep 2010 06:32:58 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Finn Thain <fthain@telegraphics.com.au>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Matt Turner <mattst88@gmail.com>,
        Dimitry Torokhov <dmitry.torokhov@gmail.com>,
        Ben Pfaff <blp@cs.stanford.edu>, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH]Update-broken-web-addresses-in-the-kernel
References: <1285042724-19135-1-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1009211518290.9370@nippy.intranet>
In-Reply-To: <alpine.LNX.2.00.1009211518290.9370@nippy.intranet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2010 02:50 AM, Finn Thain wrote:
>
> On Mon, 20 Sep 2010, Justin P. Mattock wrote:
>
>> diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
>> index b9647bb..8da39ce 100644
>> --- a/arch/alpha/Kconfig
>> +++ b/arch/alpha/Kconfig
>> @@ -219,7 +219,7 @@ config ALPHA_LX164
>>   	bool "LX164"
>>   	help
>>   	  A technical overview of this board is available at
>> -	<http://www.unix-ag.org/Linux-Alpha/Architectures/LX164.html>.
>> +	<http://www.alphalinux.org/>.
>
> I couldn't find that overview at that URL. So this change would make the
> comment go from out-of-date to flat-out-wrong.
>
> (I know that arch/alpha/** isn't to take part in this exercise, but I
> mention it anyway.)
>
>>
>>   config ALPHA_LYNX
>>   	bool "Lynx"
>> @@ -483,7 +483,7 @@ config ALPHA_AVANTI
>>   	help
>>   	  Avanti AS 200, AS 205, AS 250, AS 255, AS 300, and AS 400-based
>>   	  Alphas. Info at
>> -	<http://www.unix-ag.org/Linux-Alpha/Architectures/Avanti.html>.
>> +	<http://www.alphalinux.org/>.
>>
>>   config ALPHA_BROKEN_IRQ_MASK
>>   	bool
>
> ...
>
>> diff --git a/arch/arm/nwfpe/milieu.h b/arch/arm/nwfpe/milieu.h
>> index a3892ab..af0c1c6 100644
>> --- a/arch/arm/nwfpe/milieu.h
>> +++ b/arch/arm/nwfpe/milieu.h
>> @@ -12,8 +12,8 @@ National Science Foundation under grant MIP-9311980.  The original version
>>   of this code was written as part of a project to build a fixed-point vector
>>   processor in collaboration with the University of California at Berkeley,
>>   overseen by Profs. Nelson Morgan and John Wawrzynek.  More information
>> -is available through the Web page `http://HTTP.CS.Berkeley.EDU/~jhauser/
>> -arithmetic/softfloat.html'.
>> +is available through the Web page:
>> +http://www.jhauser.us/arithmetic/SoftFloat-2b/SoftFloat-source.txt.
>>
>>   THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort
>>   has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT
>> diff --git a/arch/arm/nwfpe/softfloat-macros b/arch/arm/nwfpe/softfloat-macros
>> index 5a060f9..64d6c4d 100644
>> --- a/arch/arm/nwfpe/softfloat-macros
>> +++ b/arch/arm/nwfpe/softfloat-macros
>> @@ -12,8 +12,8 @@ National Science Foundation under grant MIP-9311980.  The original version
>>   of this code was written as part of a project to build a fixed-point vector
>>   processor in collaboration with the University of California at Berkeley,
>>   overseen by Profs. Nelson Morgan and John Wawrzynek.  More information
>> -is available through the web page `http://HTTP.CS.Berkeley.EDU/~jhauser/
>> -arithmetic/softfloat.html'.
>> +is available through the web page:
>> +http://www.jhauser.us/arithmetic/SoftFloat-2b/SoftFloat-source.txt.
>>
>>   THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort
>>   has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT
>> diff --git a/arch/arm/nwfpe/softfloat-specialize b/arch/arm/nwfpe/softfloat-specialize
>> index d4a4c8e..a11b8ea 100644
>> --- a/arch/arm/nwfpe/softfloat-specialize
>> +++ b/arch/arm/nwfpe/softfloat-specialize
>> @@ -12,8 +12,8 @@ National Science Foundation under grant MIP-9311980.  The original version
>>   of this code was written as part of a project to build a fixed-point vector
>>   processor in collaboration with the University of California at Berkeley,
>>   overseen by Profs. Nelson Morgan and John Wawrzynek.  More information
>> -is available through the Web page `http://HTTP.CS.Berkeley.EDU/~jhauser/
>> -arithmetic/softfloat.html'.
>> +is available through the Web page:
>> +http://www.jhauser.us/arithmetic/SoftFloat-2b/SoftFloat-source.txt.
>>
>>   THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort
>>   has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT
>> diff --git a/arch/arm/nwfpe/softfloat.c b/arch/arm/nwfpe/softfloat.c
>> index 0f9656e..56f368d 100644
>> --- a/arch/arm/nwfpe/softfloat.c
>> +++ b/arch/arm/nwfpe/softfloat.c
>> @@ -11,8 +11,8 @@ National Science Foundation under grant MIP-9311980.  The original version
>>   of this code was written as part of a project to build a fixed-point vector
>>   processor in collaboration with the University of California at Berkeley,
>>   overseen by Profs. Nelson Morgan and John Wawrzynek.  More information
>> -is available through the web page `http://HTTP.CS.Berkeley.EDU/~jhauser/
>> -arithmetic/softfloat.html'.
>> +is available through the web page:
>> +http://www.jhauser.us/arithmetic/SoftFloat-2b/SoftFloat-source.txt.
>>
>>   THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort
>>   has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT
>> diff --git a/arch/arm/nwfpe/softfloat.h b/arch/arm/nwfpe/softfloat.h
>> index 13e479c..1e5ffba 100644
>> --- a/arch/arm/nwfpe/softfloat.h
>> +++ b/arch/arm/nwfpe/softfloat.h
>> @@ -12,8 +12,8 @@ National Science Foundation under grant MIP-9311980.  The original version
>>   of this code was written as part of a project to build a fixed-point vector
>>   processor in collaboration with the University of California at Berkeley,
>>   overseen by Profs. Nelson Morgan and John Wawrzynek.  More information
>> -is available through the Web page `http://HTTP.CS.Berkeley.EDU/~jhauser/
>> -arithmetic/softfloat.html'.
>> +is available through the Web page:
>> +http://www.jhauser.us/arithmetic/SoftFloat-2b/SoftFloat-source.txt.
>>
>>   THIS SOFTWARE IS DISTRIBUTED AS IS, FOR FREE.  Although reasonable effort
>>   has been made to avoid it, THIS SOFTWARE MAY CONTAIN FAULTS THAT WILL AT
>
>
> The above give a 404 with the trailing "."
>
>
>> @@ -33,5 +33,5 @@ see http://www.uclinux.org/pub/uClinux/ports/h8/
>>
>>   * A few words of thanks
>>   Porting to H8/300 serieses is support of Information-technology Promotion Agency, Japan.
>> -I thank support.
>> -and All developer/user.
>> +I thank you for all the developer/user support.
>> +
>
> This dubious edit doesn't belong in this patch. If the changelog entry
> says it will fix URLs then that's what the patch should do.
>
>
>> diff --git a/arch/ia64/include/asm/machvec_sn2.h b/arch/ia64/include/asm/machvec_sn2.h
>> index f061a30..e9d032e 100644
>> --- a/arch/ia64/include/asm/machvec_sn2.h
>> +++ b/arch/ia64/include/asm/machvec_sn2.h
>> @@ -22,7 +22,7 @@
>>    *
>>    * For further information regarding this notice, see:
>>    *
>> - * http://oss.sgi.com/projects/GenInfo/NoticeExplan
>> + * http://oss.sgi.com/
>>    */
>>
>>   #ifndef _ASM_IA64_MACHVEC_SN2_H
>
> That information I didn't find at oss.sgi.com. The old URL is
> in the web archive.
>
>
>> diff --git a/arch/ia64/sn/kernel/sn2/timer_interrupt.c b/arch/ia64/sn/kernel/sn2/timer_interrupt.c
>> index 103d6ea..9f9d5f2 100644
>> --- a/arch/ia64/sn/kernel/sn2/timer_interrupt.c
>> +++ b/arch/ia64/sn/kernel/sn2/timer_interrupt.c
>> @@ -1,6 +1,4 @@
>>   /*
>> - *
>> - *
>>    * Copyright (c) 2005, 2006 Silicon Graphics, Inc.  All Rights Reserved.
>>    *
>>    * This program is free software; you can redistribute it and/or modify it
>
> This is trivial, but it should be in a seperate patch according to the
> guidelines.
>
>> @@ -24,7 +22,7 @@
>>    *
>>    * For further information regarding this notice, see:
>>    *
>> - * http://oss.sgi.com/projects/GenInfo/NoticeExplan
>> + * http://oss.sgi.com/
>>    */
>>
>>   #include<linux/interrupt.h>
>
> See above.
>
>> diff --git a/arch/m68k/mac/macboing.c b/arch/m68k/mac/macboing.c
>> index 8f06408..f01f0db 100644
>> --- a/arch/m68k/mac/macboing.c
>> +++ b/arch/m68k/mac/macboing.c
>> @@ -114,7 +114,7 @@ static void mac_init_asc( void )
>>   			 *   16-bit I/O functionality.  The PowerBook 500 series computers
>>   			 *   support 16-bit stereo output, but only mono input."
>>   			 *
>> -			 *   http://til.info.apple.com/techinfo.nsf/artnum/n16405
>> +			 *   http://support.apple.com/kb/TA32601
>>   			 *
>>   			 * --David Kilzer
>>   			 */
>
> Please retain the TIL article number (16405), as I mentioned when I
> reviewed this last time.
>
>> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
>> index 3ad59dd..ab2330c 100644
>> --- a/arch/mips/Kconfig
>> +++ b/arch/mips/Kconfig
>> @@ -2178,7 +2178,7 @@ config TC
>>   	  TurboChannel is a DEC (now Compaq (now HP)) bus for Alpha and MIPS
>>   	  processors.  Documentation on writing device drivers for TurboChannel
>>   	  is available at:
>> -	<http://www.cs.arizona.edu/computer.help/policy/DIGITAL_unix/AA-PS3HD-TET1_html/TITLE.html>.
>> +	<http://www.linux-mips.org/wiki/Main_Page>.
>
> No, it isn't available there AFAICT.
>
>>
>>   #config ACCESSBUS
>>   #	bool "Access.Bus support"
>> diff --git a/arch/mips/math-emu/cp1emu.c b/arch/mips/math-emu/cp1emu.c
>> index 47842b7..11326c7 100644
>> --- a/arch/mips/math-emu/cp1emu.c
>> +++ b/arch/mips/math-emu/cp1emu.c
>> @@ -3,7 +3,7 @@
>>    *
>>    * MIPS floating point support
>>    * Copyright (C) 1994-2000 Algorithmics Ltd.
>> - * http://www.algor.co.uk
>> + * http://www.mips.com/
>
> ...
>
>>    *
>> - * http://www.algor.co.uk
>> + * http://www.mips.com/
>>    *
>
>> - * http://www.algor.co.uk
>> + * http://www.mips.com/
>>    *
>
>> - * http://www.algor.co.uk
>> + * http://www.mips.com/
>>    *
>
>> - * http://www.algor.co.uk
>> + * http://www.mips.com/
>>    *
>
>> - * http://www.algor.co.uk
>> + * http://www.mips.com/
>>    *
>
>> - * http://www.algor.co.uk
>> + * http://www.mips.com/
>>    *
>>    * ########################################################################
>>    *
>
>
> What is the benefit of all that churn? Why not just remove the URL, as
> you did for softwarebitmaker.com below?
>
>
>> index 4c9c67b..ef07a46 100644
>> --- a/arch/x86/kernel/apm_32.c
>> +++ b/arch/x86/kernel/apm_32.c
>> @@ -190,7 +190,7 @@
>>    *
>>    * [This document is available free from Intel by calling 800.628.8686 (fax
>>    * 916.356.6100) or 800.548.4725; or via anonymous ftp from
>> - * ftp://ftp.intel.com/pub/IAL/software_specs/apmv11.doc.  It is also
>> + * ftp://ftp.intel.com/pub/.  It is also
>
>
> Really?  I couldn't find it.
> Also, the trailing "." again.
>
>>    *	Order Number 253668 or free download from:
>>    *
>> - *	http://developer.intel.com/design/pentium4/manuals/253668.htm
>> + *	http://developer.intel.com/Assets/PDF/manual/253668.pdf	
>>    *
>>    *	For more information, go to http://www.urbanmyth.org/microcode
>>    *
>> diff --git a/arch/x86/math-emu/README b/arch/x86/math-emu/README
>> index e623549..be83144 100644
>> --- a/arch/x86/math-emu/README
>> +++ b/arch/x86/math-emu/README
>> @@ -45,10 +45,6 @@ Please report bugs, etc to me at:
>>          billm@melbpc.org.au
>>   or     b.metzenthen@medoto.unimelb.edu.au
>>
>> -For more information on the emulator and on floating point topics, see
>> -my web pages, currently at  http://www.suburbia.net/~billm/
>
> I'd suggest,
>
> -my web pages, currently at  http://www.suburbia.net/~billm/
> +my web pages, [once found] at  http://www.suburbia.net/~billm/
>
>> --- a/drivers/atm/Kconfig
>> +++ b/drivers/atm/Kconfig
>> @@ -301,7 +301,7 @@ config ATM_IA
>>   	  control memory (128K-1KVC, 512K-4KVC), the size of the packet
>>   	  memory (128K, 512K, 1M), and the PHY type (Single/Multi mode OC3,
>>   	  UTP155, UTP25, DS3 and E3). Go to:
>> -	  	<http://www.iphase.com/products/ClassSheet.cfm?ClassID=ATM>
>> +	  	<http://www.iphase.com/products/whitepapers/>
>
> Which whitepaper has info on this product? Might as well give the URL.
>
>>   	for more info about the cards. Say Y (or M to compile as a module
>>   	  named iphase) here if you have one of these cards.
>>
>
>> diff --git a/drivers/edac/edac_device_sysfs.c b/drivers/edac/edac_device_sysfs.c
>> index 0709681..413f0df 100644
>> --- a/drivers/edac/edac_device_sysfs.c
>> +++ b/drivers/edac/edac_device_sysfs.c
>> @@ -1,7 +1,7 @@
>>   /*
>>    * file for managing the edac_device class of devices for EDAC
>>    *
>> - * (C) 2007 SoftwareBitMaker (http://www.softwarebitmaker.com)
>> + * (C) 2007 SoftwareBitMaker
>>    *
>>    * This file may be distributed under the terms of the
>>    * GNU General Public License.
>> index 280c9b5..de0aca5 100644
>> --- a/drivers/firmware/Kconfig
>> +++ b/drivers/firmware/Kconfig
>> @@ -74,7 +74,7 @@ config EFI_PCDP
>>
>>   	  You must also enable the appropriate drivers (serial, VGA, etc.)
>>
>> -	  See<http://www.dig64.org/specifications/DIG64_HCDPv20_042804.pdf>
>> +	  See<http://www.dig64.org/specifications/agreement>
>
>
> Perhaps it is there, perhaps not. I'd suggest this:
>
> -	  See<http://www.dig64.org/specifications/DIG64_HCDPv20_042804.pdf>
> +	  See DIG64_HCDPv20_042804.pdf available from
> +	<http://www.dig64.org/specifications/>
>
>
>>
>>   config DELL_RBU
>>   	tristate "BIOS update support for DELL systems via sysfs"
>> diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
>> index f287fe7..acabed6 100644
>> --- a/drivers/firmware/edd.c
>> +++ b/drivers/firmware/edd.c
>> @@ -15,7 +15,7 @@
>>    * made in setup.S, copied to safe structures in setup.c,
>>    * and presents it in sysfs.
>>    *
>> - * Please see http://linux.dell.com/edd30/results.html for
>> + * Please see http://linux.dell.com/ for
>>    * the list of BIOSs which have been reported to implement EDD.
>
> I think this is the URL you are looking for:
>
> http://linux.dell.com/edd/results.html
>
>
>>    *
>>    * This program is free software; you can redistribute it and/or modify
>> diff --git a/drivers/firmware/pcdp.h b/drivers/firmware/pcdp.h
>> index ce910d6..faa0225 100644
>> --- a/drivers/firmware/pcdp.h
>> +++ b/drivers/firmware/pcdp.h
>> @@ -1,8 +1,7 @@
>>   /*
>>    * Definitions for PCDP-defined console devices
>>    *
>> - * v1.0a: http://www.dig64.org/specifications/DIG64_HCDPv10a_01.pdf
>> - * v2.0:  http://www.dig64.org/specifications/DIG64_PCDPv20.pdf
>> + * Specification's: http://www.dig64.org/specifications/agreement
>
>
> See above.
>
>> diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
>> index 949326d..59251d2 100644
>> --- a/drivers/gpu/drm/drm_modes.c
>> +++ b/drivers/gpu/drm/drm_modes.c
>> @@ -76,7 +76,7 @@ EXPORT_SYMBOL(drm_mode_debug_printmodeline);
>>    * according to the hdisplay, vdisplay, vrefresh.
>>    * It is based from the VESA(TM) Coordinated Video Timing Generator by
>>    * Graham Loveridge April 9, 2003 available at
>> - * http://www.vesa.org/public/CVT/CVTd6r1.xls
>> + * http://www.vesa.org/
>
> Eh?
>
> As I pointed out in an earlier email, this loses information.
>
> Before your patch, the file name can be googled up:
>
> http://www.elo.utfsm.cl/~elo212/docs/CVTd6r1.xls
>
> (Probably this is the same file.)
>
> And yet the file cannot be found at all at the URL you gave.
>
>
>>    *
>>    * And it is copied from xf86CVTmode in xserver/hw/xfree86/modes/xf86cvt.c.
>>    * What I have done is to translate it by using integer calculation.
>> diff --git a/drivers/hwmon/adcxx.c b/drivers/hwmon/adcxx.c
>> index fbdc765..8803ed9 100644
>> --- a/drivers/hwmon/adcxx.c
>> +++ b/drivers/hwmon/adcxx.c
>> @@ -14,7 +14,7 @@
>>    *   and 101 for 1 MSPS)
>>    *
>>    * Complete datasheets are available at National's website here:
>> - * http://www.national.com/ds/DC/ADC<bb><c>S<sss>.pdf
>> + * http://www.national.com/products/catalog.do
>
> Wrong. Google this and you will see what I mean.
>
> site:www.national.com inurl:ds/DC
>
>>    *
>>    * Handling of 8, 10 and 12 bits converters are the same, the
>>    * unavailable bits are 0 :)
>> diff --git a/drivers/hwmon/adm1025.c b/drivers/hwmon/adm1025.c
>> index 251b631..7b7f9c2 100644
>> --- a/drivers/hwmon/adm1025.c
>> +++ b/drivers/hwmon/adm1025.c
>> @@ -12,7 +12,7 @@
>>    * resolution of about 0.5% of the nominal value). Temperature values are
>>    * reported with a 1 deg resolution and a 3 deg accuracy. Complete
>>    * datasheet can be obtained from Analog's website at:
>> - *   http://www.analog.com/Analog_Root/productPage/productHome/0,2121,ADM1025,00.html
>> + *  http://www.analog.com/en/content/Parts_List_Sold_to_On_Semiconductor/fca.html
>
>
> The URL you are looking for is
> http://www.onsemi.com/PowerSolutions/product.do?id=ADM1025
>
>
>>    *
>>    * This driver also supports the ADM1025A, which differs from the ADM1025
>>    * only in that it has "open-drain VID inputs while the ADM1025 has
>> diff --git a/drivers/hwmon/adm1026.c b/drivers/hwmon/adm1026.c
>> index 65335b2..b1e0882 100644
>> --- a/drivers/hwmon/adm1026.c
>> +++ b/drivers/hwmon/adm1026.c
>> @@ -6,7 +6,7 @@
>>
>>       Chip details at:
>>
>> -<http://www.analog.com/UploadedFiles/Data_Sheets/779263102ADM1026_a.pdf>
>> +<http://www.analog.com/en/content/Parts_List_Sold_to_On_Semiconductor/fca.html>
>
>
> http://www.onsemi.com/PowerSolutions/product.do?id=ADM1026
>
>
>>
>>       This program is free software; you can redistribute it and/or modify
>>       it under the terms of the GNU General Public License as published by
>> diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
>> index 4516369..d876275 100644
>> --- a/drivers/ide/hpt366.c
>> +++ b/drivers/ide/hpt366.c
>> @@ -12,7 +12,7 @@
>>    *
>>    *
>>    * HighPoint has its own drivers (open source except for the RAID part)
>> - * available from http://www.highpoint-tech.com/BIOS%20+%20Driver/.
>> + * available from http://www.highpoint-tech.com/.
>
> Did you check for drivers available there? I don't see them.
>
>
>>    * This may be useful to anyone wanting to work on this driver, however  do not
>>    * trust  them too much since the code tends to become less and less meaningful
>>    * as the time passes... :-/
>
>> diff --git a/drivers/ide/sgiioc4.c b/drivers/ide/sgiioc4.c
>> index e3ea591..baecd2b 100644
>> --- a/drivers/ide/sgiioc4.c
>> +++ b/drivers/ide/sgiioc4.c
>> @@ -16,7 +16,7 @@
>>    *
>>    * For further information regarding this notice, see:
>>    *
>> - * http://oss.sgi.com/projects/GenInfo/NoticeExplan
>> + * http://oss.sgi.com/projects/failsafe/docs/LnxFailSafe_PG/html/fpcontent.html
>
>
> See above comment regarding the same NoticeExplan URL.
>
>
>>    */
>>
>>   #include<linux/module.h>
>> diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
>> index 89d70de..cf769f1 100644
>> --- a/drivers/infiniband/Kconfig
>> +++ b/drivers/infiniband/Kconfig
>> @@ -16,7 +16,7 @@ config INFINIBAND_USER_MAD
>>   	  Userspace InfiniBand Management Datagram (MAD) support.  This
>>   	  is the kernel side of the userspace MAD support, which allows
>>   	  userspace processes to send and receive MADs. You will also
>> -	  need libibumad from<http://www.openib.org>.
>> +	  need libibumad from<http://openfabrics.org/>.
>>
>>   config INFINIBAND_USER_ACCESS
>>   	tristate "InfiniBand userspace access (verbs and CM)"
>> @@ -28,7 +28,7 @@ config INFINIBAND_USER_ACCESS
>>   	  to set up connections and directly access InfiniBand
>>   	  hardware for fast-path operations.  You will also need
>>   	  libibverbs, libibcm and a hardware driver library from
>> -	<http://www.openib.org>.
>> +	<git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git>.
>
> These two chunks indicate that libibumad is available from
> openfabrics.org, but libibcm is not? Is that correct?
>
>
>>
>>   config INFINIBAND_USER_MEM
>>   	bool
>>   	  Please send feedback to<linux-bugs@chelsio.com>.
>>
>> diff --git a/drivers/infiniband/ulp/iser/Kconfig b/drivers/infiniband/ulp/iser/Kconfig
>> index b411c51..9273f44 100644
>> --- a/drivers/infiniband/ulp/iser/Kconfig
>> +++ b/drivers/infiniband/ulp/iser/Kconfig
>> @@ -9,4 +9,4 @@ config INFINIBAND_ISER
>>
>>   	  The iSER protocol is defined by IETF.
>>   	  See<http://www.ietf.org/rfc/rfc5046.txt>
>> -	  and<http://www.infinibandta.org/members/spec/Annex_iSER.PDF>
>> +	  and<http://www.infinibandta.org/content/pages.php?pg=technology_download>
>
>
> Again you've lost useful information. I can google Annex_iSER filetype:pdf
> and find the pdf here: http://members.infinibandta.org/kwspub/spec/Annex_iSER.PDF
>
> If I follow your link, I need to register.
>
>
>> diff --git a/drivers/input/joystick/gamecon.c b/drivers/input/joystick/gamecon.c
>> index 0ffaf2c..2463b95 100644
>> --- a/drivers/input/joystick/gamecon.c
>> +++ b/drivers/input/joystick/gamecon.c
>> @@ -521,9 +521,8 @@ static void gc_multi_process_packet(struct gc *gc)
>>    * PSX support
>>    *
>>    * See documentation at:
>> - *	http://www.dim.com/~mackys/psxmemcard/ps-eng2.txt
>> + *	http://forethought.net/	
>
>
> Who is forethought.net?
> I can see how this edit will benefit the search ranking and advertising
> objectives of that enterprise, but I fail to see the benefit for Linux
> development.
>
>
>>    *	http://www.gamesx.com/controldata/psxcont/psxcont.htm
>> - *	ftp://milano.usal.es/pablo/
>>    *
>>    */
>>
>>    */
>> diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
>> index c714ca2..a29a870 100644
>> --- a/drivers/input/mouse/Kconfig
>> +++ b/drivers/input/mouse/Kconfig
>> @@ -27,10 +27,7 @@ config MOUSE_PS2
>>
>>   	  Synaptics, ALPS or Elantech TouchPad users might be interested
>>   	  in a specialized Xorg/XFree86 driver at:
>> -		<http://w1.894.telia.com/~u89404340/touchpad/index.html>
>> -	  and a new version of GPM at:
>> -		<http://www.geocities.com/dt_or/gpm/gpm.html>
>> -	  to take advantage of the advanced features of the touchpad.
>> +		<http://cgit.freedesktop.org/xorg/driver/xf86-input-synaptics/>
>
> This needs ACK from the appropriate maintainer.
>
>>
>>   	If unsure, say Y.
>>
>> diff --git a/drivers/input/mouse/touchkit_ps2.c b/drivers/input/mouse/touchkit_ps2.c
>> index 88121c5..d362c7a 100644
>> --- a/drivers/input/mouse/touchkit_ps2.c
>> +++ b/drivers/input/mouse/touchkit_ps2.c
>> @@ -22,7 +22,7 @@
>>    * Based upon touchkitusb.c
>>    *
>>    * Vendor documentation is available in support section of:
>> - * http://www.egalax.com.tw/
>> + * http://home.eeti.com.tw/web20/eg/drivers.htm
>
> I see linux drivers but no vendor docs...
>
>>    */
>>
>>   #include<linux/kernel.h>
>>    * Result is stored into an sk_buff and queued up for later
>>    * evaluation.
>> diff --git a/drivers/isdn/i4l/isdn_net.c b/drivers/isdn/i4l/isdn_net.c
>> index 26d44c3..6aab456 100644
>> --- a/drivers/isdn/i4l/isdn_net.c
>> +++ b/drivers/isdn/i4l/isdn_net.c
>> @@ -19,7 +19,7 @@
>>    *
>>    * Jan 2001: fix CISCO HDLC      Bjoern A. Zeeb<i4l@zabbadoz.net>
>>    *           for info on the protocol, see
>> - *           http://i4l.zabbadoz.net/i4l/cisco-hdlc.txt
>> + *          http://www.nethelp.no/net/cisco-hdlc.txt
>>    */
>
> It is in the web archive:
>
> http://web.archive.org/web/*/patch.zabbadoz.net/i4l/cisco-hdlc.txt
>
>
>>
>>   #include<linux/isdn.h>
>
>
>> --- a/drivers/media/radio/radio-maxiradio.c
>> +++ b/drivers/media/radio/radio-maxiradio.c
>> @@ -13,7 +13,7 @@
>>    * anybody does please mail me.
>>    *
>>    * For the pdf file see:
>> - * http://www.semiconductors.philips.com/pip/TEA5757H/V1
>> + * http://www.nxp.com/
>
>> From the old URL, I was able to quickly google up this:
>
> http://www.nxp.com/acrobat_download2/expired_datasheets/TEA5757_5759_3.pdf
>
>>    *
>>    *
>>    * CHANGES:
>> diff --git a/drivers/media/video/cx23885/cx23885-417.c b/drivers/media/video/cx23885/cx23885-417.c
>> index abd64e8..64ae3f9 100644
>> --- a/drivers/media/video/cx23885/cx23885-417.c
>> +++ b/drivers/media/video/cx23885/cx23885-417.c
>> @@ -7,7 +7,7 @@
>>    *    (c) 2008 Steven Toth<stoth@linuxtv.org>
>>    *      - CX23885/7/8 support
>>    *
>> - *  Includes parts from the ivtv driver( http://ivtv.sourceforge.net/),
>> + *  Includes parts from the ivtv driver(http://ivtvdriver.org/index.php/Main_Page),
>
>
> No. If it says it includes parts from http://sourceforge.net/projects/ivtv/
> then that's the correct URL.
>
>>    *
>>    *  This program is free software; you can redistribute it and/or modify
>>    *  it under the terms of the GNU General Public License as published by
>> diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
>> index e46e1ce..645f840 100644
>> --- a/drivers/media/video/cx88/cx88-blackbird.c
>> +++ b/drivers/media/video/cx88/cx88-blackbird.c
>> @@ -9,7 +9,7 @@
>>    *    (c) 2005-2006 Mauro Carvalho Chehab<mchehab@infradead.org>
>>    *        - video_ioctl2 conversion
>>    *
>> - *  Includes parts from the ivtv driver( http://ivtv.sourceforge.net/),
>> + *  Includes parts from the ivtv driver(http://ivtvdriver.org/index.php/Main_Page),
>
> Same again.
>
>
>>    *
>>    *  This program is free software; you can redistribute it and/or modify
>>    *  it under the terms of the GNU General Public License as published by
>> diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
>> index b984610..a76b468 100644
>> --- a/drivers/media/video/gspca/gspca.c
>> +++ b/drivers/media/video/gspca/gspca.c
>> @@ -2337,7 +2337,7 @@ EXPORT_SYMBOL(gspca_resume);
>>   /* -- cam driver utility functions -- */
>>
>>   /* auto gain and exposure algorithm based on the knee algorithm described here:
>> -   http://ytse.tricolour.net/docs/LowLightOptimization.html
>> +   http://81.209.78.62:8080/docs/LowLightOptimization.html
>
> I suggest you keep the old link. Add the new one if you wish but
> it probably won't be valid for long.
>
>
>>
>>      Returns 0 if no changes were made, 1 if the gain and or exposure settings
>>      where changed. */
>> --- a/drivers/media/video/saa7134/saa7134-cards.c
>> +++ b/drivers/media/video/saa7134/saa7134-cards.c
>> @@ -2343,8 +2343,8 @@ struct saa7134_board saa7134_boards[] = {
>>   		},
>>   	},
>>   	[SAA7134_BOARD_BEHOLD_409FM] = {
>> -		/*<http://tuner.beholder.ru>, Sergey<skiv@orel.ru>  */
>> -		/*       Beholder Intl. Ltd. 2008      */
>> +		/*<http://www.beholder.ru/bb/viewtopic.php?t=1142>, */
>> +		/*  Sergey<skiv@orel.ru>  Beholder Intl. Ltd. 2008 */
>
>
> The old link is in the web archive, so no need to remove it.
>
>
>>   		/*Dmitry Belimov<d.belimov@gmail.com>  */
>>   		.name           = "Beholder BeholdTV 409 FM",
>>   		.audio_clock    = 0x00187de7,
>>   config PHANTOM
>> diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
>> index 1e2cbf5..6f08a26 100644
>> --- a/drivers/mtd/Kconfig
>> +++ b/drivers/mtd/Kconfig
>> @@ -292,9 +292,9 @@ config RFD_FTL
>>   	---help---
>>   	  This provides support for the flash translation layer known
>>   	  as the Resident Flash Disk (RFD), as used by the Embedded BIOS
>> -	  of General Software. There is a blurb at:
>> +	  of General Software.
>>
>> -		http://www.gensw.com/pages/prod/bios/rfd.htm
>> +		http://www.phoenix.com/	
>
> Eh? The old link is in the web archive, the one you propose
> doesn't have any relevant information.
>
>
>>
>>   config SSFDC
>>   	tristate "NAND SSFDC (SmartMedia) read only translation layer"
>> diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
>> index 3e6c47b..17f5305 100644
>> --- a/drivers/mtd/chips/cfi_cmdset_0002.c
>> +++ b/drivers/mtd/chips/cfi_cmdset_0002.c
>> @@ -418,8 +418,7 @@ struct mtd_info *cfi_cmdset_0002(struct map_info *map, int primary)
>>
>>   			/*
>>   			 * Valid primary extension versions are: 1.0, 1.1, 1.2, 1.3, 1.4
>> -			 * see: http://www.amd.com/us-en/assets/content_type/DownloadableAssets/cfi_r20.pdf, page 19
>> -			 *      http://www.amd.com/us-en/assets/content_type/DownloadableAssets/cfi_100_20011201.pdf
>> +			 * see: http://www.amd.com/
>
> Really?
>
> If I google, "cfi_r20.pdf" filetype:pdf
> then I can get the docs. But you would remove the search key from the
> source code?
>
>
>>   			*      http://www.spansion.com/Support/Datasheets/s29ws-p_00_a12_e.pdf
>>   			 */
>>   			if (extp->MajorVersion != '1' ||
>>    *
>>    * Limitations:
>>    *
>> diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
>> index 4d6a64c..030e963 100644
>> --- a/drivers/mtd/ftl.c
>> +++ b/drivers/mtd/ftl.c
>> @@ -51,7 +51,7 @@
>>
>>       Use of the FTL format for non-PCMCIA applications may be an
>>       infringement of these patents.  For additional information,
>> -    contact M-Systems (http://www.m-sys.com) directly.
>> +    contact (http://www.sandisk.com/).
>
>
> I would use,
>
> - contact M-Systems (http://www.m-sys.com) directly.
> + contact M-Systems directly. [M-Systems since acquired by Sandisk.]
>
>
>>
>>   ======================================================================*/
>>   #include<linux/mtd/blktrans.h>
>> diff --git a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
>> index 701d942..5d32e20 100644
>> --- a/drivers/mtd/maps/Kconfig
>> +++ b/drivers/mtd/maps/Kconfig
>> @@ -172,7 +172,7 @@ config MTD_OCTAGON
>>   	  This provides a 'mapping' driver which supports the way in which
>>   	  the flash chips are connected in the Octagon-5066 Single Board
>>   	  Computer. More information on the board is available at
>> -	<http://www.octagonsystems.com/CPUpages/5066.html>.
>> +	<http://www.octagonsystems.com/products/5066.aspx>.
>>
>>   config MTD_VMAX
>>   	tristate "JEDEC Flash device mapped on Tempustech VMAX SBC301"
>> @@ -256,8 +256,7 @@ config MTD_DILNETPC
>>   	depends on X86&&  MTD_CONCAT&&  MTD_PARTITIONS&&  MTD_CFI_INTELEXT&&  BROKEN
>>   	help
>>   	  MTD map driver for SSV DIL/Net PC Boards "DNP" and "ADNP".
>> -	  For details, see<http://www.ssv-embedded.de/ssv/pc104/p169.htm>
>> - 	  and<http://www.ssv-embedded.de/ssv/pc104/p170.htm>
>> +	  For details, see<http://www.ssv-embedded.de/>
>
>
> Once again, the web archive has the page but your link has nothing
> relevant that I can find.
>
>
>>
>>   config MTD_DILNETPC_BOOTSIZE
>>   	hex "Size of DIL/Net PC flash boot partition"
>> @@ -284,7 +283,7 @@ config MTD_TQM8XXL
>>   	  chips, currently uses AMD one. This 'mapping' driver supports
>>   	  that arrangement, allowing the CFI probe and command set driver
>>   	  code to communicate with the chips on the TQM8xxL board. More at
>> -	<http://www.denx.de/embedded-ppc-en.html>.
>> +	<http://www.denx.de/en/News/WebHome>.
>
>
> I think you want,
>
> http://www.denx.de/wiki/PPCEmbedded/
>
>>
>>   config MTD_RPXLITE
>>   	tristate "CFI Flash device mapped on RPX Lite or CLLF"
>> @@ -351,7 +350,7 @@ config MTD_DC21285
>>   	help
>>   	  This provides a driver for the flash accessed using Intel's
>>   	  21285 bridge used with Intel's StrongARM processors. More info at
>> -	<http://www.intel.com/design/bridge/docs/21285_documentation.htm>.
>> +	<http://downloadcenter.intel.com/Detail_Desc.aspx?agr=Y&DwnldID=5719&lang=eng>.
>
> That download is the .ibs circuit model for use with CAD by design
> engineers. It is not relevant to kernel programmers.
>
>
>>
>>   	This driver does not create any MTD maps itself; instead it
>>   	  creates MTD physmap and MTD SRAM platform devices.  If you
>> diff --git a/drivers/mtd/maps/dilnetpc.c b/drivers/mtd/maps/dilnetpc.c
>> index 0713e3a..63d0997 100644
>> --- a/drivers/mtd/maps/dilnetpc.c
>> +++ b/drivers/mtd/maps/dilnetpc.c
>> @@ -19,8 +19,7 @@
>>    * board: DNP/1486 and ADNP/1486. The DNP version has 2 megs of flash
>>    * ROM (Intel 28F016S3) and 8 megs of DRAM, the ADNP version has 4 megs
>>    * flash and 16 megs of RAM.
>> - * For details, see http://www.ssv-embedded.de/ssv/pc104/p169.htm
>> - * and http://www.ssv-embedded.de/ssv/pc104/p170.htm
>> + * For details, see http://www.ssv-comm.de/en/products/index.php
>>    */
>
> See comment above re same URL.
>
>
>>
>>   #include<linux/module.h>
>> diff --git a/drivers/mtd/rfd_ftl.c b/drivers/mtd/rfd_ftl.c
>> index cc4d180..482493d 100644
>> --- a/drivers/mtd/rfd_ftl.c
>> +++ b/drivers/mtd/rfd_ftl.c
>> @@ -6,7 +6,7 @@
>>    * This type of flash translation layer (FTL) is used by the Embedded BIOS
>>    * by General Software. It is known as the Resident Flash Disk (RFD), see:
>>    *
>> - *	http://www.gensw.com/pages/prod/bios/rfd.htm
>> + *	http://www.phoenix.com/	
>
> Same here: old URL is archived, yours is unhelpful.
>
>
>>    *
>>    * based on ftl.c
>>    */
>> diff --git a/drivers/net/8139too.c b/drivers/net/8139too.c
>> index f5166dc..d6f23e5 100644
>> --- a/drivers/net/8139too.c
>> +++ b/drivers/net/8139too.c
>> @@ -28,7 +28,7 @@
>>   		MD 21403
>>
>>   		Support and updates available at
>> -		http://www.scyld.com/network/rtl8139.html
>> +		http://www.penguincomputing.com/	
>
>
> Eh? What's the connection between the beowulf.org sponsor and this
> driver?
>
> In anycase, the old URL is in the web archive, so no patch is needed.
>
>>
>>   		Twister-tuning table provided by Kinston
>>   		<shangh@realtek.com.tw>.
>> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
>> index 2cc81a5..a026fd7 100644
>> --- a/drivers/net/Kconfig
>> +++ b/drivers/net/Kconfig
>> @@ -169,9 +169,7 @@ config NET_SB1000
>>   	  a connection. Further documentation and the necessary scripts can be
>>   	  found at:
>>
>> -	<http://www.jacksonville.net/~fventuri/>
>> -	<http://home.adelphia.net/~siglercm/sb1000.html>
>> -	<http://linuxpower.cx/~cable/>
>
>
> These links are all in the web archive, please do not remove them.
>
>
>> +	<http://web.archive.org/web/*/http://www.jacksonville.net/~fventuri/>
>>
>>   	If you don't have this card, of course say N.
>>
>
>>   	tristate "National Semiconductor DP8381x series PCI Ethernet support"
>> @@ -1552,7 +1546,7 @@ config NATSEMI
>>   	  which is used in cards from PureData, NetGear, Linksys
>>   	  and others, including the 83815 chip.
>>   	  More specific information and updates are available from
>> -	<http://www.scyld.com/network/natsemi.html>.
>> +	<http://www.penguincomputing.com/>.
>>
>>   config NE2K_PCI
>>   	tristate "PCI NE2000 and clones support (see help)"
>> @@ -1703,7 +1697,7 @@ config EPIC100
>>   	  This driver is for the SMC EtherPower II 9432 PCI Ethernet NIC,
>>   	  which is based on the SMC83c17x (EPIC/100).
>>   	  More specific information and updates are available from
>> -	<http://www.scyld.com/network/epic100.html>.
>> +	<http://www.penguincomputing.com/>.
>>
>>   config SMSC9420
>>   	tristate "SMSC LAN9420 PCI ethernet adapter support"
>
>> @@ -1729,7 +1723,7 @@ config SUNDANCE
>>   	help
>>   	  This driver is for the Sundance "Alta" chip.
>>   	  More specific information and updates are available from
>> -	<http://www.scyld.com/network/sundance.html>.
>> +	<http://www.penguincomputing.com/>.
>
>
> Again, can be found at archive.org, no patch needed.
>
>
>>
>>   config SUNDANCE_MMIO
>>   	bool "Use MMIO instead of PIO"
>
>> @@ -3048,7 +3042,6 @@ config PLIP
>>   	<file:Documentation/networking/PLIP.txt>.  The cables can be up to
>>   	  15m long.  Mode 0 works also if one of the machines runs DOS/Windows
>>   	  and has some PLIP software installed, e.g. the Crynwr PLIP packet
>> -	  driver (<http://oak.oakland.edu/simtel.net/msdos/pktdrvr-pre.html>)
>
>
> Same
>
>
>>   	and winsock or NCSA's telnet.
>>
>>   	  If you want to use PLIP, say Y and read the PLIP mini-HOWTO as well
>> @@ -3262,8 +3255,8 @@ config SLIP_COMPRESSED
>>   	<ftp://ibiblio.org/pub/Linux/system/network/serial/>) which
>>   	  allows you to use SLIP over a regular dial up shell connection, you
>>   	  definitely want to say Y here. The NET-3-HOWTO, available from
>> -	<http://www.tldp.org/docs.html#howto>, explains how to configure
>> -	  CSLIP. This won't enlarge your kernel.
>> +	<http://web.archive.org/web/*/http://www.bart.nl/~patrickr/term-howto/Term-HOWTO.html>,
>> +	  explains how to configure CSLIP. This won't enlarge your kernel.
>
>
> That's not the same document. It isn't even related to SLIP. I would change only this:
> -         definitely want to say Y here. The NET-3-HOWTO, available from
> +         definitely want to say Y here. The NET3-4-HOWTO, available from
>
>
>>
>>   config SLHC
>>   	tristate
>>
>>   static int ace_get_settings(struct net_device *, struct ethtool_cmd *);
>>   static int ace_set_settings(struct net_device *, struct ethtool_cmd *);
>> diff --git a/drivers/net/appletalk/Kconfig b/drivers/net/appletalk/Kconfig
>> index 0a0e0cd..9368cfa 100644
>> --- a/drivers/net/appletalk/Kconfig
>> +++ b/drivers/net/appletalk/Kconfig
>> @@ -10,15 +10,15 @@ config ATALK
>>   	  wish to connect to it, say Y.  You will need to use the netatalk package
>>   	  so that your Linux box can act as a print and file server for Macs as
>>   	  well as access AppleTalk printers.  Check out
>> -	<http://www.zettabyte.net/netatalk/>  on the WWW for details.
>> +	<http://cgi.zettabyte.net/>  on the WWW for details.
>
>
> Notwithstanding problems on the server, the original URL is better.
>
>
>>   	EtherTalk is the name used for AppleTalk over Ethernet and the
>>   	  cheaper and slower LocalTalk is AppleTalk over a proprietary Apple
>>   	  network using serial links.  EtherTalk and LocalTalk are fully
>>   	  supported by Linux.
>>
>>   	  General information about how to connect Linux, Windows machines and
>> -	  Macs is on the WWW at<http://www.eats.com/linux_mac_win.html>.  The
>> -	  NET-3-HOWTO, available from
>> +	  Macs is on the WWW at<http://en.wikibooks.org/wiki/Linux_Networking/Appletalk_%28AF_APPLETALK%29>.
>> +	  The NET-3-HOWTO, available from
>
> In this case, the domain has changed hands, so you have to link to
> web.archive.org for the eats.com link.
>
> http://web.archive.org/web/20011204193118/http://www.eats.com/linux_mac_win.html
>
>
> NET-3-HOWTO could be changed to NET3-4-HOWTO, as above.
>
>
>>   	<http://www.tldp.org/docs.html#howto>, contains valuable
>>   	  information as well.
>>
>>
>>   					Theory of Operation
>>
>> diff --git a/drivers/net/epic100.c b/drivers/net/epic100.c
>> index 57c8ac0..b9a934b 100644
>> --- a/drivers/net/epic100.c
>> +++ b/drivers/net/epic100.c
>> @@ -18,8 +18,7 @@
>>   	Annapolis MD 21403
>>
>>   	Information and updates available at
>> -	http://www.scyld.com/network/epic100.html
>> -	[this link no longer provides anything useful -jgarzik]
>
>
> This is in the web archive, so no patch needed.
> I can't read the site you linked to.
>
>
>> +	http://www.silan.com.cn/All/Default.aspx	
>>
>>   	---------------------------------------------------------------------
>>
>>
>> diff --git a/drivers/net/fealnx.c b/drivers/net/fealnx.c
>> index d7e8f6b..759d456 100644
>> --- a/drivers/net/fealnx.c
>> +++ b/drivers/net/fealnx.c
>> @@ -14,7 +14,7 @@
>>   	Annapolis MD 21403
>>
>>   	Support information and updates available at
>> -	http://www.scyld.com/network/pci-skeleton.html
>> +	http://www.penguincomputing.com/	
>
> See above.
>
>
>>
>>   	Linux kernel updates:
>>
>> diff --git a/drivers/net/hamachi.c b/drivers/net/hamachi.c
>> index 49aac70..f4523cd 100644
>> --- a/drivers/net/hamachi.c
>> +++ b/drivers/net/hamachi.c
>> @@ -20,9 +20,6 @@
>>
>>   	Support and updates available at
>>   	http://www.scyld.com/network/hamachi.html
>> -	[link no longer provides useful info -jgarzik]
>> -	or
>> -	http://www.parl.clemson.edu/~keithu/hamachi.html
>
>
> This is wrong.
>
>
>>
>>   */
>>
>> diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
>> index 62d5d5c..1faa85b 100644
>> --- a/drivers/net/hamradio/Kconfig
>> +++ b/drivers/net/hamradio/Kconfig
>> @@ -73,7 +73,7 @@ config DMASCC
>>   	  certain parameters, such as channel access timing, clock mode, and
>>   	  DMA channel. This is accomplished with a small utility program,
>>   	  dmascc_cfg, available at
>> -	<http://cacofonix.nt.tuwien.ac.at/~oe1kib/Linux/>. Please be sure to
>> +	<http://www.linux-ax25.org/wiki/LinuxAX25>. Please be sure to
>
>
> http://www.linux-ax25.org/wiki/Ax25-tools
>
>
>>   	get at least version 1.27 of dmascc_cfg, as older versions will not
>>   	  work with the current driver.
>>
>
>> diff --git a/drivers/net/irda/donauboe.h b/drivers/net/irda/donauboe.h
>> index 36c3060..9e9a82d 100644
>> --- a/drivers/net/irda/donauboe.h
>> +++ b/drivers/net/irda/donauboe.h
>> @@ -54,7 +54,7 @@
>>   /* anyone who has. HOWEVER the chip bears a striking resemblence */
>>   /* to the IrDA controller in the Toshiba RISC TMPR3922 chip      */
>>   /* the documentation for this is freely available at             */
>> -/* http://www.toshiba.com/taec/components/Generic/TMPR3922.shtml */
>
> This is in the web archive, so no patch needed.
>
>> +/* http://www.toshiba.com/tai/					 */
>
> There is nothing relevant here.
>
>
>>   /* The mapping between the registers in that document and the    */
>>   /* Registers in the 701 oboe chip are as follows    */
>>
>> diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
>> index a6033d4..a8c6d3c 100644
>> --- a/drivers/net/natsemi.c
>> +++ b/drivers/net/natsemi.c
>> @@ -19,9 +19,7 @@
>>   	Annapolis MD 21403
>>
>>   	Support information and updates available at
>> -	http://www.scyld.com/network/netsemi.html
>> -	[link no longer provides useful info -jgarzik]
>> -
>> +	http://www.penguincomputing.com/	
>>
>>   	TODO:
>>   	* big endian support with CFG:BEM instead of cpu_to_le32
>> @@ -207,9 +205,7 @@ recieve and transmit paths which are synchronised using a combination of
>>   hardware descriptor ownership, disabling interrupts and NAPI poll scheduling.
>>
>>   IVb. References
>> -
>> -http://www.scyld.com/expert/100mbps.html
>> -http://www.scyld.com/expert/NWay.html
>> +http://www.penguincomputing.com/
>
>
> More scyld.com links, see above.
>
>
>>   Datasheet is available from:
>>   http://www.national.com/pf/DP/DP83815.html
>>
>>
>> diff --git a/drivers/net/pci-skeleton.c b/drivers/net/pci-skeleton.c
>> index 56f3fc4..d654eff 100644
>> --- a/drivers/net/pci-skeleton.c
>> +++ b/drivers/net/pci-skeleton.c
>> @@ -78,7 +78,7 @@ that almost all frames will need to be copied to an alignment buffer.
>>
>>   IVb. References
>>
>> -http://www.realtek.com.tw/cn/cn.html
>> +http://www.realtek.com.tw/
>>   http://www.scyld.com/expert/NWay.html
>
> Good.
>
>
>>
>>   IVc. Errata
>> @@ -106,7 +106,7 @@ IVc. Errata
>>
>>   static char version[] __devinitdata =
>>   	KERN_INFO NETDRV_DRIVER_LOAD_MSG "\n"
>> -	"  Support available from http://foo.com/bar/baz.html\n";
>> +	"  Support available from linux-wireless@vger.kernel.org\n";
>
>
> This file is a template. It is intended to be like that.
>
>
>>
>>   /* define to 1 to enable PIO instead of MMIO */
>>   #undef USE_IO_OPS
>
>> diff --git a/drivers/net/sc92031.c b/drivers/net/sc92031.c
>> index 8c4067a..fd94fa1 100644
>> --- a/drivers/net/sc92031.c
>> +++ b/drivers/net/sc92031.c
>> @@ -15,7 +15,7 @@
>>    *  Rewritten for 2.6 by Cesar Eduardo Barros
>>    *
>>    *  A datasheet for this chip can be found at
>> - *  http://www.silan.com.cn/english/products/pdf/SC92031AY.pdf
>> + *  http://www.silan.com.cn/All/Default.aspx
>
> The URL has changed to,
>
> http://www.silan.com.cn/english/product/pdf/SC92031AY.pdf
>
>
>>    */
>>
>>   /* Note about set_mac_address: I don't know how to change the hardware
>>   /*
>> diff --git a/drivers/net/starfire.c b/drivers/net/starfire.c
>> index a42b687..3ce0c78 100644
>> --- a/drivers/net/starfire.c
>> +++ b/drivers/net/starfire.c
>> @@ -21,8 +21,7 @@
>>   	Annapolis MD 21403
>>
>>   	Support and updates available at
>> -	http://www.scyld.com/network/starfire.html
>> -	[link no longer provides useful info -jgarzik]
>> +	http://www.penguincomputing.com/	
>>
>>   */
>>
>> @@ -282,8 +281,7 @@ IV. Notes
>>   IVb. References
>>
>>   The Adaptec Starfire manuals, available only from Adaptec.
>> -http://www.scyld.com/expert/100mbps.html
>> -http://www.scyld.com/expert/NWay.html
>> +http://www.penguincomputing.com/
>>
>>   IVc. Errata
>>
>> diff --git a/drivers/net/sundance.c b/drivers/net/sundance.c
>> index 2678588..02bdc27 100644
>> --- a/drivers/net/sundance.c
>> +++ b/drivers/net/sundance.c
>> @@ -15,7 +15,7 @@
>>   	Annapolis MD 21403
>>
>>   	Support and updates available at
>> -	http://www.scyld.com/network/sundance.html
>> +	http://www.penguincomputing.com/	
>>   	[link no longer provides useful info -jgarzik]
>>   	Archives of the mailing list are still available at
>>   	http://www.beowulf.org/pipermail/netdrivers/
>> @@ -193,8 +193,7 @@ IVb. References
>>   The Sundance ST201 datasheet, preliminary version.
>>   The Kendin KS8723 datasheet, preliminary version.
>>   The ICplus IP100 datasheet, preliminary version.
>> -http://www.scyld.com/expert/100mbps.html
>> -http://www.scyld.com/expert/NWay.html
>> +http://www.penguincomputing.com/
>>
>>   IVc. Errata
>>
>
>
> All these are scyld.com links, see above.
>
>
>> - * 			       http://tlan.kernel.dk
>> + * 			       http://hp.sourceforge.net/
>>    *
>>    * 	v1.7 April 07, 2000  - Started to implement custom ioctls. Driver now
>>    * 			       reports PHY information when used with Donald
>> diff --git a/drivers/net/tokenring/Kconfig b/drivers/net/tokenring/Kconfig
>> index c4137b0..d490b50 100644
>> --- a/drivers/net/tokenring/Kconfig
>> +++ b/drivers/net/tokenring/Kconfig
>> @@ -100,8 +100,7 @@ config TMS380TR
>>   	  read the Token-Ring mini-HOWTO, available from
>>   	<http://www.tldp.org/docs.html#howto>.
>>
>> -	  Also read the file<file:Documentation/networking/tms380tr.txt>  or
>> -	  check<http://www.auk.cx/tms380tr/>.
>
>
> The domain changed hands, so you might give the full date-stamped URL:
>
> http://web.archive.org/web/20000902203240/http://www.auk.cx/tms380tr/
>
>
>> +	  Also read the file<file:Documentation/networking/tms380tr.txt>
>>
>>   	To compile this driver as a module, choose M here: the module will be
>>   	  called tms380tr.
>
>> diff --git a/drivers/net/usb/plusb.c b/drivers/net/usb/plusb.c
>> index 08555f8..c928261 100644
>> --- a/drivers/net/usb/plusb.c
>> +++ b/drivers/net/usb/plusb.c
>> @@ -32,7 +32,7 @@
>>
>>
>>   /*
>> - * Prolific PL-2301/PL-2302 driver ... http://www.prolifictech.com
>> + * Prolific PL-2301/PL-2302 driver ...http://www.prolific.com.tw/
>
> The space before the http would be good.
>
>
> I've only reviewed one third of this patch but I'll stop here. You
> get the idea.
>
> It would be easier to review a patch without churn like this:
> http://foo/bar ->  http://web.archive.org/web/*/foo/bar
>
> If you must, you could do this in a separate patch.
> IMHO it only adds bloat (aside from the archive.org URLs for domains that
> changed hands such that the datestamp is significant)
>
> Also, you need to split the patch and send the relevant parts to the
> relevant people, to avoid wasting reviewers' time.
>
> A word of advice: it doesn't matter an iota if all the URLs in the kernel
> are 404s. What matters is to improve on any one of them (even if it isn't
> a 404).
>
> Finn
>


alright... looks like I've got's my works cuts out's fors me's....
I'll try and do this, asap...

Thanks..

Justin P. Mattock
