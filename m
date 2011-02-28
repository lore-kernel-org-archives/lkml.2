Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1B1Od7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 09:33:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46120 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753918Ab1B1Od6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 09:33:58 -0500
Date: Mon, 28 Feb 2011 14:34:18 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeng Zhaoming <zhaoming.zeng@freescale.com>
Subject: Re: linux-next: build failure after merge of the sound and
 sound-asoc trees
Message-ID: <20110228143418.GB13869@opensource.wolfsonmicro.com>
References: <20110228141528.00fc4ab4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110228141528.00fc4ab4.sfr@canb.auug.org.au>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 02:15:28PM +1100, Stephen Rothwell wrote:

> After merging the sound tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

I've applied a fix for this from Zjaoming.
