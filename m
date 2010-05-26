Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933937Ab0EZByt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:54:49 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:37469 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab0EZByr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:54:47 -0400
Date: Wed, 26 May 2010 10:54:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Magnus Damm <damm@opensource.se>
Subject: Re: linux-next: manual merge of the genesis tree with the sh tree
Message-ID: <20100526015436.GB8920@linux-sh.org>
References: <20100526112331.cbd37c4b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100526112331.cbd37c4b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 11:23:31AM +1000, Stephen Rothwell wrote:
> Hi Paul,
> 
> Today's linux-next merge of the genesis tree got a conflict in
> include/linux/serial_sci.h between commit
> 14baf9d7f275f0bbf42c1216ff1eef1109ca42ba ("serial: sh-sci: fix up serial
> DMA build") from the sh tree and commit
> 927a7c9c1793def3a55d60c926d3945528e6bf1b ("dmaengine: shdma: Enable on
> SH-Mobile ARM") from the genesis tree.
> 
Sorry about that, I needed the fix in the sh tree since the genesis tree
hadn't been merged yet, so the interdependencies have created a bit of a
mess.

> I used the version from the sh tree (i.e. no "#ifdef
> CONFIG_SERIAL_SH_SCI_DMA" around the include of linux/sh_dma.h).

Sounds good, thanks!
