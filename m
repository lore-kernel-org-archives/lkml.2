Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2EBRej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 13:34:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58944 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab2EBReh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 13:34:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120427143745.GD27535@alberich.amd.com>
References: <20120427143410.GB27535@alberich.amd.com> <20120427143745.GD27535@alberich.amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 2 May 2012 11:34:15 -0600
Message-ID: <CAErSpo584dcpGhmp-jcP_Zsznmz9ZkfPuxpF3UK9UVfcnFUdRA@mail.gmail.com>
Subject: Re: [PATCH 2/2][RESEND] x86/pci/amd: Enable early_fill_mp_bus_to_node
 on AMD family 15h models 0-0xf
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 8:37 AM, Andreas Herrmann
<andreas.herrmann3@amd.com> wrote:
>
> While at it avoid calling this function on family 11h (aka Griffin)
> which was a mobile part and doesn't support NUMA.

This changelog doesn't seem like it goes with this patch.  It looks
more related to the first patch (though that affects family 11h and
greater, not just family 11h).

> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/pci/amd_bus.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
> index 0384e69..d552b29 100644
> --- a/arch/x86/pci/amd_bus.c
> +++ b/arch/x86/pci/amd_bus.c
> @@ -27,7 +27,7 @@ static struct pci_hostbridge_probe pci_probes[] __initdata = {
>        { 0, 0x18, PCI_VENDOR_ID_AMD, 0x1100 },
>        { 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
>        { 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
> -       { 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 },
> +       { 0, 0x18, PCI_VENDOR_ID_AMD, 0x1600 },
>  };
>
>  /**
> --
> 1.7.8.5
>
>
>
