Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab0EJXbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:31:48 -0400
Received: from crca.org.au ([74.207.252.120]:36922 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757969Ab0EJXbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 19:31:40 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BE89757.4000307@tuxonice.net>
Date: Tue, 11 May 2010 09:31:35 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Daniel T Chen <crimsun@ubuntu.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [51/98] ALSA: hda: Use STAC_DELL_M6_BOTH quirk for Dell Studio
 1558
References: <20100510223538.998531361@kvm.kroah.org>
In-Reply-To: <20100510223538.998531361@kvm.kroah.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

On 11/05/10 08:35, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: Daniel T Chen<crimsun@ubuntu.com>
>
> commit 5c1bccf645d4ab65e4c7502acb42e8b9afdb5bdc upstream.
>
> BugLink: https://launchpad.net/bugs/568600
>
> The OR has verified that the dell-m6 model quirk is necessary for audio
> to be audible by default on the Dell Studio XPS 1645.

My previous comment (commit message doesn't match code) applies here too.

Regards,

Nigel

> This change is necessary for 2.6.32.11 and 2.6.33.2 alike.
>
> Reported-by: Andy Ross<andy@plausible.org>
> Tested-by: Andy Ross<andy@plausible.org>
> Signed-off-by: Daniel T Chen<crimsun@ubuntu.com>
> Signed-off-by: Takashi Iwai<tiwai@suse.de>
> Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
>
> ---
>   sound/pci/hda/patch_sigmatel.c |    2 ++
>   1 file changed, 2 insertions(+)
>
> --- a/sound/pci/hda/patch_sigmatel.c
> +++ b/sound/pci/hda/patch_sigmatel.c
> @@ -1594,6 +1594,8 @@ static struct snd_pci_quirk stac92hd73xx
>   				"Dell Studio 1557", STAC_DELL_M6_DMIC),
>   	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x02fe,
>   				"Dell Studio XPS 1645", STAC_DELL_M6_BOTH),
> +	SND_PCI_QUIRK(PCI_VENDOR_ID_DELL, 0x0413,
> +				"Dell Studio 1558", STAC_DELL_M6_BOTH),
>   	{} /* terminator */
>   };
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

