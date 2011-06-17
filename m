Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1FQC4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 22:56:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57167 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab1FQC4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 22:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fBN5hhVlGc6F0Qo8VSDicDjVzVk8kifWr/Vax5G12ifD37dg9777hXawyv3L3uH1m9
         0/gVVsd+mszJAa3DNZsT/q4ls8wOIVAH4jwXi2rXUPOD2VAhjoHA47HkQFvNC9pi8P2+
         epHI4IcD26763ptrL0xzFrM/K+7pdyear/AVY=
Message-ID: <4DFAC242.9090204@gmail.com>
Date: Fri, 17 Jun 2011 12:56:02 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jiri Kosina <jkosina@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mika Westerberg <mika.westerberg@iki.fi>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: linux-next: manual merge of the trivial tree with the slave-dma
 tree
References: <20110617125419.c196ca92.sfr@canb.auug.org.au>
In-Reply-To: <20110617125419.c196ca92.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/06/11 12:54, Stephen Rothwell wrote:
> Hi Jiri,
>
> Today's linux-next merge of the trivial tree got a conflict in
> arch/arm/mach-ep93xx/dma-m2p.c between commit 8e4a93008db7 ("ep93xx:
> remove the old M2P DMA code") from the slave-dma tree and commit
> 1c5454eed85a ("Change Ryan Mallon's email address across the kernel")
> from the trivial tree.
>
> The former removed the file, so I did that.

That is correct. Mika has added my new email address to the new ep93xx 
dma files.

Thanks,
~Ryan
