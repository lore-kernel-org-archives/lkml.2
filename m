Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab0IVQ1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:27:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36029 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab0IVQ1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=gqYxSBm25We0iok+UzegoPB0pGMWWjq8WkkSku1MG3vrRAmadtbErY/9n5+mI1iIL8
         SYoHKqL79QliRZYZ5v1fG80JPnMxol3TD/VJyUf88f8UPf7nIh5uiDYN/g3WO60brgeW
         Vpnl0tMpjEkhdSI1CF043zzig6j/+TM/LtCNo=
MIME-Version: 1.0
In-Reply-To: <20100922145737.GA12663@linux-mips.org>
References: <1285156021-4973-1-git-send-email-jkacur@redhat.com>
	<20100922145737.GA12663@linux-mips.org>
Date: Wed, 22 Sep 2010 18:27:46 +0200
X-Google-Sender-Auth: lWliCi2HNXNzdCVze1Uyw2vHAFo
Message-ID: <AANLkTi=L9vJ9Bfek8HGb30c0U949H0EgiXX7oHxj-F_=@mail.gmail.com>
Subject: Re: [PATCH] SOUND-OSS: Remove sh_dac_audio
From: John Kacur <jkacur@redhat.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 4:57 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Wed, Sep 22, 2010 at 01:47:01PM +0200, John Kacur wrote:
>
>> Remove the SH DAC oss driver since there is an equivalent alsa driver.
>> oss has been deprecated for years. Furthermore this driver has BKL code
>> which we are trying to remove. Rather than attempt to fix this, simply
>> remove the driver.
>>
>> Signed-off-by: John Kacur <jkacur@redhat.com>
>
> No idea why I was cc'ed as I have no interested in the driver but certainly
> support the motivation behind the patch:
>
> Acked-by: Ralf Baechle <ralf@linux-mips.org>
>

Thanks. FWIW, I cced you because you were part of the original conversation
back in the Stone Ages (or maybe it was just May) about removing certain
OSS drivers that had equivalent ALSA drivers.
