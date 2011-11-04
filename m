Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab1KDC1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 22:27:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab1KDC1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 22:27:38 -0400
From: Thomas Renninger <trenn@suse.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: Fix reboot issue for Dell Optiplex 990 V2
Date: Fri, 4 Nov 2011 04:27:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: x86@kernel.org, Ismail Donmez <idoenmez@suse.de>, stable@kernel.org
References: <1320373471-3942-1-git-send-email-trenn@suse.de>
In-Reply-To: <1320373471-3942-1-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201111040427.38472.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 November 2011 03:24:30 Thomas Renninger wrote:
> This was the only (reboot=p) option that worked for this desktop.
> Default does not reboot as well.
> 
> V2: Remove copy and paste left over from another machine
> 
> CC: Ismail Donmez <idoenmez@suse.de>
> CC: stable@kernel.org
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> ---
>  arch/x86/kernel/reboot.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index e334be1..a6875b1 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -443,6 +443,15 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
>  			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
>  		},
>  	},
> +	{	/* Handle problems with rebooting on the Latitude E6420. */
Arghh, I forgot guilt refresh.
I'll resend...

   Thomas
