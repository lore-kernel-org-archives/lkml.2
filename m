Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab1JLJKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 05:10:44 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48593 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab1JLJKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 05:10:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAP2e6W-sSQP-5Xb_-38=j17pX8jJeTzuA2VCaCu3b6ERrCMQhw@mail.gmail.com>
References: <1318260152-2786-1-git-send-email-mark.einon@gmail.com>
 <CAP2e6W9oQWLxe7pJxk=Awn1HTueeu41ZV7TFF+V9tHF07_Mxag@mail.gmail.com>
 <20111011161153.GA6697@suse.de> <CANK3SE1tdJm93BK+U01Ep7Q2B=+aUJmgxkrQ537oPrqB2YZ4nA@mail.gmail.com>
 <CAP2e6W9BCV5Wg5rTLrDLaU45NCt9PaSV5zZHT5OA88hqNvounw@mail.gmail.com>
 <CAHj3AVnRzOQEVJu6sfE-pZt9QN_q75Pf6LEeGfdKm-NdxjFC_Q@mail.gmail.com> <CAP2e6W-sSQP-5Xb_-38=j17pX8jJeTzuA2VCaCu3b6ERrCMQhw@mail.gmail.com>
From: Mark Einon <mark.einon@gmail.com>
Date: Wed, 12 Oct 2011 10:10:22 +0100
Message-ID: <CANK3SE2N0NCpJbSZhSV7utJAZuMwudxe-t3Nw+YcR48kKiR2SA@mail.gmail.com>
Subject: Re: [PATCH 4/4] staging: et131x: Update TODO list
To: Ramesh R <rshlinux@gmail.com>
Cc: Denis Kirjanov <kirjanov@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 October 2011 03:37, Ramesh R <rshlinux@gmail.com> wrote:
> I could work on item #1,

Actually, I have some patches for that ready to post this evening. Any
other item is good, however.

> ==
>  TODO:
> +       - Put the driver into a single file, with a .h for the registers layout.
> +       - rx_ring.fbr{0, 1} can probably share a common structure
> +       - Use of kmem_cache seems a bit unusual
> +       - Use dma_alloc_... in place of pci_alloc_...
> +       - It's too late stopping the tx queue when there is no room
> for the current packet. The condition should be detected for the next
> packet.
> +       - PCI_VDEVICE ?
>
> ==
>
> I looked up for ET 1310 on ebay, amazon & few other sites like digikey
> - I couldnt find the device. Can you please let me know where I can
> buy the hardware?

I'm afraid I can't be of much help with that - its quite hard to get hold of.
I believe the chip is a few years old, not made anymore and was not
widely sold when it was.
I managed to get hold of a card from eBay via a seller in France.

Mark
