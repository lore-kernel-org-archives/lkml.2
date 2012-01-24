Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab2AXJpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 04:45:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43645 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab2AXJpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 04:45:38 -0500
Message-ID: <4F1E7DC0.5060208@canonical.com>
Date: Tue, 24 Jan 2012 10:45:36 +0100
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Seth Heasley <seth.heasley@intel.com>
CC: tiwai@suse.de, alsa-devel@alsa-project.org, perex@perex.cz,
        james.d.ralston@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 1/6] hda_intel: Add Lynx Point HD Audio Controller
 DeviceIDs
References: <201201231624.31275.seth.heasley@intel.com>
In-Reply-To: <201201231624.31275.seth.heasley@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2012 01:24 AM, Seth Heasley wrote:
> This patch adds the HD Audio DeviceIDs for the Intel Lynx Point PCH.

Thanks. As we asked for oak trail: can you confirm you prefer DMA 
Position buffers for detecting current playback/recording position, over 
using the LPIB register?

Also; these types of quirks should have a line "Cc: stable@kernel.org" 
added to their commit messages, that will make it automatically be 
applied to some of the older kernels in due time.

>
> Signed-off-by: Seth Heasley<seth.heasley@intel.com>
> ---
>   sound/pci/hda/hda_intel.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
> index 0852e20..adb4fa7 100644
> --- a/sound/pci/hda/hda_intel.c
> +++ b/sound/pci/hda/hda_intel.c
> @@ -148,6 +148,7 @@ MODULE_SUPPORTED_DEVICE("{{Intel, ICH6},"
>   			 "{Intel, PCH},"
>   			 "{Intel, CPT},"
>   			 "{Intel, PPT},"
> +			 "{Intel, LPT},"
>   			 "{Intel, PBG},"
>   			 "{Intel, SCH},"
>   			 "{ATI, SB450},"
> @@ -2989,6 +2990,10 @@ static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
>   	{ PCI_DEVICE(0x8086, 0x1e20),
>   	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_SCH_SNOOP |
>   	  AZX_DCAPS_BUFSIZE},
> +	/* Lynx Point */
> +	{ PCI_DEVICE(0x8086, 0x8c20),
> +	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_SCH_SNOOP |
> +	  AZX_DCAPS_BUFSIZE},
>   	/* SCH */
>   	{ PCI_DEVICE(0x8086, 0x811b),
>   	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_SCH_SNOOP |



-- 
David Henningsson, Canonical Ltd.
http://launchpad.net/~diwic
