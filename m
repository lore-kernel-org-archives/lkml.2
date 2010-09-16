Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0IPKnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 06:43:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48084 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753085Ab0IPKnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 06:43:35 -0400
Date: Thu, 16 Sep 2010 11:43:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: linux-next: manual merge of the sound-asoc tree with the
 genesis tree
Message-ID: <20100916104333.GC7837@rakim.wolfsonmicro.main>
References: <20100915121128.d8fbc4bb.sfr@canb.auug.org.au>
 <20100915095021.GB1866@rakim.wolfsonmicro.main>
 <Pine.LNX.4.64.1009151344410.31624@axis700.grange>
 <w3pfwxawlt5.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w3pfwxawlt5.wl%kuninori.morimoto.gx@renesas.com>
X-Cookie: Now I am depressed ...
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 09:53:42AM +0900, Kuninori Morimoto wrote:

> If I (for sound) and Guennadi (for video) would like to add
> new patches to it in future (in same time),
> what should I do ?

Ideally the patches will be layering on top of the changes in one tree
or the other so you can follow the affected tree.  Once the merge window
is over they should be going via the video route.
