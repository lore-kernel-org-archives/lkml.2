Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab1AJSuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:50:06 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:7865 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab1AJSuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:50:04 -0500
Message-Id: <~B4d2b4c9a0000.4d2b550b0000.0001.mml.1716753652@caviumnetworks.com>
Date: Mon, 10 Jan 2011 10:14:02 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: correct fucked grammar in mips ops-bridge.c
References: <20110110181052.GA20090@redhat.com>
In-Reply-To: <20110110181052.GA20090@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jan 2011 18:14:02.0952 (UTC) FILETIME=[292C1480:01CBB0F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 10:10 AM, Dave Jones wrote:
> I had no idea just how broken IOC3 was until I read this.
>
> Signed-off-by: Dave Jones<davej@redhat.com>
>
> diff --git a/arch/mips/pci/ops-bridge.c b/arch/mips/pci/ops-bridge.c
> index b46b3e2..4383194 100644
> --- a/arch/mips/pci/ops-bridge.c
> +++ b/arch/mips/pci/ops-bridge.c
> @@ -56,7 +56,7 @@ static int pci_conf0_read_config(struct pci_bus *bus, unsigned int devfn,
>   		return PCIBIOS_DEVICE_NOT_FOUND;
>
>   	/*
> -	 * IOC3 is fucked fucked beyond believe ...  Don't even give the
> +	 * IOC3 is fucking fucked beyond belief ...  Don't even give the
>   	 * generic PCI code a chance to look at it for real ...
>   	 */

Probably it should read:

* IOC3 is fucked, fucked beyond belief. ...



David Daney
