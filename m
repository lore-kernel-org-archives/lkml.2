Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab1DFVCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:02:55 -0400
Received: from relais.videotron.ca ([24.201.245.36]:45207 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1DFVCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:02:54 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 06 Apr 2011 17:02:53 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Cooper <ecc@cmu.edu>
Subject: Re: [PATCH 2/2] ARM: Remove machine type dockstar (use sheevaplug
 instead)
In-reply-to: <1302122121-3652-3-git-send-email-holler@ahsoftware.de>
Message-id: <alpine.LFD.2.00.1104061700440.28032@xanadu.home>
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de>
 <1302122121-3652-3-git-send-email-holler@ahsoftware.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Apr 2011, Alexander Holler wrote:

> There is no need to have a different machine type for Seagate DockStars.
> Remove it.
> 
> Be aware, this patch requires a change in the bootloader to feed the
> same machine type to the kernel as used for Marvell SheevaPlugs.

This is therefore not a good idea to do this.

If the SheevaPlug setup code can be reused as is for DockStars, then it 
is best to simply add an additional machine record along with the 
SheevaPlug one.


Nicolas
