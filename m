Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1I2E4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 00:56:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59762 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab1I2E4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 00:56:08 -0400
Message-ID: <4E83FA65.8060600@canonical.com>
Date: Thu, 29 Sep 2011 06:56:05 +0200
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110925 Thunderbird/7.0
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: Re: [228/244] ALSA: HDA: No power nids on 92HD93
References: <20110928220149.403768579@clark.kroah.org>
In-Reply-To: <20110928220149.403768579@clark.kroah.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

thanks for applying this patch, but it makes little sense to do so 
without the other patch "ALSA: HDA: Add support for IDT 92HD93" 
(46724c2e023cb7ba5cd50) added a few days earlier (with cc to stable).

Can you tell me why the above patch was not applied, and in case it did 
not apply cleanly, the location of the tree I need to fix it up against?

On 09/29/2011 12:03 AM, Greg KH wrote:
> 3.0-stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: David Henningsson<david.henningsson@canonical.com>
>
> commit 6656b15d675c9c6a049db48d50994b3cd4e76bd6 upstream.
>
> This patch is necessary to make internal speakers work on this chip.
>
> BugLink: http://bugs.launchpad.net/bugs/854468
> Tested-by: Alex Wolfson<alex.wolfson@canonical.com>
> Signed-off-by: David Henningsson<david.henningsson@canonical.com>
> Signed-off-by: Takashi Iwai<tiwai@suse.de>
> Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
>
> ---
>   sound/pci/hda/patch_sigmatel.c |    1 +
>   1 file changed, 1 insertion(+)
>
> --- a/sound/pci/hda/patch_sigmatel.c
> +++ b/sound/pci/hda/patch_sigmatel.c
> @@ -5470,6 +5470,7 @@ again:
>   	switch (codec->vendor_id) {
>   	case 0x111d76d1:
>   	case 0x111d76d9:
> +	case 0x111d76df:
>   	case 0x111d76e5:
>   	case 0x111d7666:
>   	case 0x111d7667:
>
>



-- 
David Henningsson, Canonical Ltd.
http://launchpad.net/~diwic
