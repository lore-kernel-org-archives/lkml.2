Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab1BPRlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:41:47 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:52233 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab1BPRlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:41:44 -0500
Date: Wed, 16 Feb 2011 19:41:40 +0200 (EET)
From: Aaro Koskinen <aaro.koskinen@iki.fi>
X-X-Sender: aaro@loser
To: linux-fbdev@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] sisfb: XGI Z9 POST
In-Reply-To: <1297635088-13224-1-git-send-email-aaro.koskinen@iki.fi>
Message-ID: <alpine.DEB.1.10.1102161916510.479@loser>
References: <1297635088-13224-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 14 Feb 2011, Aaro Koskinen wrote:
> Here's some patches to get POST working with XGI Z9. I have tested them
> with the following card:
>
> 	http://www.roboard.com/Files/RB-100/MiniPCI-VGA-Z9s_UM_v1r1A.pdf
>
> I'm using the card on an ARM board where the bootloader knows nothing
> about VGA or VGA BIOS, so having POST support in the kernel driver
> is mandatory. With these patches the memory size is correct detected,
> R/W test passes and it's possible to use e.g. framebuffer console.
>
> Aaro Koskinen (6):
>  sisfb: POST should fail if R/W test fails
>  sisfb: move XGI POST RAM type detection into a subroutine
>  sisfb: add subroutine for detecting XGI Z9
>  sisfb: add RAM type detection for XGI Z9
>  sisfb: move XGI POST DDR2 bootup code into subroutines
>  sisfb: add support for XGI Z9 DDR2 POST

Hmm, I think these patches can be ignored, at least for a while.

I realized that xgifb driver is now in staging, and it has much wider
support for XGI chips. So, we should work on getting that driver into
an acceptable form. And after that, it should be even possible to drop
XGI support from sisfb.

A.
