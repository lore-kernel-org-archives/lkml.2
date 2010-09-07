Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab0IGN2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:28:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36445 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab0IGN23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:28:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Kcgpfrh24gCM9waT1WIuk//U8EwgXN+AnQVgBMrTlUm43VUuzt1hnn4LM37k2YMCMY
         ztU+RUnjaermRo6+0Dt2yPwpoPDsNyJmjmAXrdtD4q4Q3w7EoGp8790nwjechfUEi22g
         2my6xHKyUfBwrTRimaj2HV/IWb/HmGDAx2tN0=
Message-ID: <4C863E1D.3050600@gmail.com>
Date: Tue, 07 Sep 2010 06:29:01 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Tony Wan <visual2me@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Fwd: anyone can help me about nand_get_flash_type
References: <AANLkTim=JEuHBXXqVFOJ4ozXGSEVxjuCt7sOpXcox-NQ@mail.gmail.com> <AANLkTikyM=XmFp2RSQtiHpoF3gVZKyEfpDFg2_Cd_ssW@mail.gmail.com>
In-Reply-To: <AANLkTikyM=XmFp2RSQtiHpoF3gVZKyEfpDFg2_Cd_ssW@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2010 11:37 PM, Tony Wan wrote:
> Anyone can help me with this problem? even some ideas how to debug and
> find the problem? Thank you!
>
>
> ---------- Forwarded message ----------
> From: Tony Wan<visual2me@gmail.com>
> Date: Wed, Aug 25, 2010 at 5:36 PM
> Subject: anyone can help me about nand_get_flash_type
> To: linux-mtd@lists.infradead.org
>
>
> Hi there,
>
> I got an ARM device from Marvell with a NAND rom, running Linux
> 2.6.22.18. These days I'm working on upgrading the kernel to 2.6.31.8.
> After the upgrade, all devices work well except the NAND rom. I found
> it's because that the device and manufacturer IDs cannot be retrieved
> correctly in nand_get_flash_type.  In 2.6.22.18, the IDs can be
> retrieved as expected; but in 2.6.31.8, the IDs always be 0, which
> leads to an error in nand_scan.
>
> I'm a definitely newbie with MTD, and currently have no idea about the
> problem. Except IO_ADDR_R&  IO_ADDR_W are remapped to different
> addresses, I can't find any differences between the 2 versions from
> the system log -- may it be the reason? Anyone can give me some tips
> about this problem -- how to fix it or how to debug? Any suggestions
> will be appreciated.
>
> --
> Best regards,
> Tony Wan
>
>
>


in this case if 2.6.22 worked and 2.6.31 is broken Id suggest bisecting 
this, since you have a good/bad starting point.
http://linux.yyz.us/git-howto.html

Justin P. Mattock
