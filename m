Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab0L1CRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 21:17:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48467 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752988Ab0L1CRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 21:17:36 -0500
Date: Tue, 28 Dec 2010 02:17:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20101228021747.GB30589@opensource.wolfsonmicro.com>
References: <20101228104024.fb0e9e34.sfr@canb.auug.org.au>
 <20101228104834.84202d88.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101228104834.84202d88.sfr@canb.auug.org.au>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 10:48:34AM +1100, Stephen Rothwell wrote:

> Mark, I reversed the order of the trees today ...

That's expected, Takashi is on holiday at the minute so not updating his
tree.  Merging ASoC first will mean you get the fixes in ASoC plus the
additional stuff in the sound tree which seems more sensible.
