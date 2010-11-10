Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab0KJL1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 06:27:30 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:46887 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab0KJL11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 06:27:27 -0500
Date: Wed, 10 Nov 2010 20:27:02 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Thomas Winischhofer <thomas@winischhofer.net>
Subject: Re: [PATCHv2] sisfb: limit POST memory test according to PCI resource length
Message-ID: <20101110112702.GB1475@linux-sh.org>
References: <1289387059-31760-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289387059-31760-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 01:04:19PM +0200, Aaro Koskinen wrote:
> If the POST memory test fails, the driver may access illegal
> memory areas. Instead of hard coding the maximum size, set it
> according to the PCI resource length (an additional check is needed in
> sisfb_post_map_vram() to ensure it's big enough). DRAM sizing will later
> adjust video_size to the correct value.
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> Cc: Thomas Winischhofer <thomas@winischhofer.net>
> ---
> 
> v2: Add a check to sisfb_post_map_vram().
> 

Queued for .37, thanks.
