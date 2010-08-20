Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab0HTXBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 19:01:17 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41690 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0HTXBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 19:01:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N1gUwE38gpDD2CmSBixlWqpa5Sey2Ido2XYeBLrmgbfcR2yu/OJC/Q0abmijNdH/cp
         uycQGm/J9jRKWxeOv2eC0duCTAZs15n/bUijR/igE6/DUfh6HjsvY3u6QbU7kc25N6nr
         HmQkHr8oeOH0moPAafD4RGe8NllK8FrkxUxZA=
MIME-Version: 1.0
In-Reply-To: <4C6E9A0A.6060205@arndnet.de>
References: <4C4555DA.40203@renesas.com>
	<4C6E9A0A.6060205@arndnet.de>
Date: Sat, 21 Aug 2010 08:01:11 +0900
Message-ID: <AANLkTi=SziDSARkgJikGMtfTvyY+K8g+o=QykZGfwmsv@mail.gmail.com>
Subject: Re: [PATCH] tmio_mmc: Allow 2 byte requests in 4-bit mode
From: Magnus Damm <magnus.damm@gmail.com>
To: Arnd Hannemann <arnd@arndnet.de>
Cc: Yusuke Goda <yusuke.goda.sx@renesas.com>, ian@mnementh.co.uk,
        damm@opensource.se, sameo@linux.intel.com,
        Paul Mundt <lethal@linux-sh.org>, g.liakhovetski@gmx.de,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 12:06 AM, Arnd Hannemann <arnd@arndnet.de> wrote:
> Am 20.07.2010 09:52, schrieb Yusuke Goda:
>> Adjust the tmio_mmc block size check to accept 2-byte requests in
>> 4-bit mode. Tested with the SDHI hardware block included in sh7724.
>>
>> Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
>
> Tested on AP4EVB (sh7372) with SDHC and MMC cards - no regression.
>
> Tested-by: Arnd Hannemann <arnd@arndnet.de>

Hi Arnd,

With both you, Goda-san and me testing it certainly looks like this
one also is ok on platforms with SDHI.

Thanks a lot!

/ magnus
