Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0LCXeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 18:34:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51360 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab0LCXen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 18:34:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JalNIxtFw79nOXOf2wmGN8irt3QJNoMq2Lz7jiq4PTC8HBTOmbYredN5wx+Tq9yebu
         pO+KvPCjqzpCPfnz5FsMTpJ9mx66DiauOQzglVfxUAJWdJdrx05/wt0eGopXFNcENXe/
         h8zi7x0myAyG9xEV57Po/4mYkSiTuomqJAzsM=
MIME-Version: 1.0
In-Reply-To: <1290510371-23077-1-git-send-email-jamie@jamieiles.com>
References: <1290510371-23077-1-git-send-email-jamie@jamieiles.com>
Date: Fri, 3 Dec 2010 15:34:41 -0800
X-Google-Sender-Auth: ZLePNc9ObJBIp_PxrrM8FYz4I64
Message-ID: <AANLkTimjWEDWaz75-DSemfyNBUU7VLVhd7qzPpD-Lk5N@mail.gmail.com>
Subject: Re: [PATCH 0/4] dmaengine/dw_dmac: enhancements to allow use on other platforms
From: Dan Williams <dan.j.williams@intel.com>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, hskinnemoen <hskinnemoen@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 3:06 AM, Jamie Iles <jamie@jamieiles.com> wrote:
> Hi,
>
> This patch series makes a couple of small changes to allow the dw_dmac driver
> to be used on other platforms in addition to the current Atmel part. This
> includes allowing controllers to be marked as private by the platform code and
> to allow the source and destination AXI/AHB masters to be defined by the
> platform.
>
> Jamie Iles (4):
>      dmaengine/dw_dmac: don't scan descriptors if no xfers in progress
>      dmaengine/dw_dmac: allow src/dst masters to be configured at runtime
>      dmaengine/dw_dmac: provide a mechanism to indicate private devices
>      avr32: at32ap700x: specify DMA src and dst masters
>
>  arch/avr32/mach-at32ap/at32ap700x.c |    6 +++++
>  drivers/dma/dw_dmac.c               |   36 +++++++++++++++++++++-------------
>  include/linux/dw_dmac.h             |    5 ++++
>  3 files changed, 33 insertions(+), 14 deletions(-)

Hi,

Looks like this whole series needs to go through the dmaengine tree
but you missed cc'ing me on patch 4/4, found it now.

I'd like an acked-by from Haavard, but otherwise looks good.

--
Dan
