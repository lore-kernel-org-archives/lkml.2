Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339Ab1DFVoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:44:11 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:48534 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab1DFVoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:44:08 -0400
Message-ID: <4D9CDE85.4050007@ahsoftware.de>
Date: Wed, 06 Apr 2011 23:43:33 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Nicolas Pitre <nico@fluxnic.net>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Cooper <ecc@cmu.edu>
Subject: Re: [PATCH 2/2] ARM: Remove machine type dockstar (use sheevaplug
 instead)
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de> <1302122121-3652-3-git-send-email-holler@ahsoftware.de> <alpine.LFD.2.00.1104061700440.28032@xanadu.home>
In-Reply-To: <alpine.LFD.2.00.1104061700440.28032@xanadu.home>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.04.2011 23:02, Nicolas Pitre wrote:
> On Wed, 6 Apr 2011, Alexander Holler wrote:
>
>> There is no need to have a different machine type for Seagate DockStars.
>> Remove it.
>>
>> Be aware, this patch requires a change in the bootloader to feed the
>> same machine type to the kernel as used for Marvell SheevaPlugs.
>
> This is therefore not a good idea to do this.

The original bootloader isn't affected at all, only already modified 
ones which are using the machine type dockstar. And I don't think this 
are that many because that machine type was only supported for one or 
two revisions of U-Boot.

Regards,

Alexander Holler
