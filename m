Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab2DAUua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 16:50:30 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:33972 "EHLO
	homiemail-a49.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752603Ab2DAUu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 16:50:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=FtjeFxE1OBkGgRq/mOR3fAFIrzCNPbPrQnaC2ttvsmk6QGD1VP9nRCtuqo7mq
	/23i7Uzq2i12OPrjJXA2QzoGeRMSSsZU/QEe1X4px6yIrV1sNee46vP+Iidf7J80
	z4Nr5rtCHL4qwdXvawl+rPOjQ5kltg7z+LO27Ll/9MJQnk=
Message-ID: <4F78BF92.70304@shealevy.com>
Date: Sun, 01 Apr 2012 16:50:26 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120321 Thunderbird/11.0
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Tracey Dent <tdent48227@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mchehab@infradead.org,
        hans.verkuil@cisco.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] Drivers/media/radio: Fix build error
References: <1333307374-25848-1-git-send-email-tdent48227@gmail.com> <201204012124.48701.hverkuil@xs4all.nl>
In-Reply-To: <201204012124.48701.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2012 03:24 PM, Hans Verkuil wrote:
> No, this is the correct patch:
>
> diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
> index 8816804..5ca0939 100644
> --- a/sound/pci/Kconfig
> +++ b/sound/pci/Kconfig
> @@ -2,8 +2,8 @@
>
>   config SND_TEA575X
>   	tristate
> -	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2
> -	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2
> +	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2 || RADIO_MAXIRADIO
> +	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2 || RADIO_MAXIRADIO
>
>   menuconfig SND_PCI
>   	bool "PCI sound devices"

Builds now, thanks.

Tested-by: Shea Levy <shea@shealevy.com>

Cheers,
Shea
