Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1BXIwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 03:52:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34047 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1BXIwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 03:52:53 -0500
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the  tree
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nayak, Rajendra" <rnayak@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Guruswamy, Senthilvadivu" <svadivu@ti.com>
In-Reply-To: <20110224142316.6706625a.sfr@canb.auug.org.au>
References: <20110224142316.6706625a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 10:52:38 +0200
Message-ID: <1298537558.16119.33.camel@deskari>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2011-02-23 at 21:23 -0600, Stephen Rothwell wrote:
> Hi Tomi,
> 
> Today's linux-next merge of the omap_dss2 tree got a conflict in
> arch/arm/mach-omap2/board-3430sdp.c between commit
> 73a92aa4f1d6786eaa5b4e637eee648db0dfd7a7 ("omap3sdp: clean regulator
> supply mapping in board file") from the omap tree and commit
> b3e0ccec47b179b0d3a7bfdb9df7112e508b009c ("OMAP2,3 DSS2 Change driver
> name to omap_display") from the omap_dss2 tree.
> 
> I fixed it up (see below) and can carry this fix as necessary (though I
> have no idea if it is correct).
> 
> [The merge today did, however, lose most of the other conflicts, thanks]

It seems there was a small conflict resolution error when Tony merged my
patches (an extra regulator supply was left in the code). I fixed that
and rebased my tree on Tony's for-linus branch.

So I hope that now we're finally free of non-trivial conflicts =).

Thanks again.

 Tomi


