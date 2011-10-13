Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab1JMPRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:17:40 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:59461 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270Ab1JMPRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:17:37 -0400
X-Sasl-enc: yoVc1huKVGUYBuCY23bJ/rTxC7FMi1XWukTtw6fHHc+x 1318519056
Date: Thu, 13 Oct 2011 09:10:14 -0600
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: linux-next: manual merge of the staging tree with the fbdev tree
Message-ID: <20111013151014.GA28061@kroah.com>
References: <20111013170225.254bc2d590deee544913ab6c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111013170225.254bc2d590deee544913ab6c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 05:02:25PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/xgifb/XGI_main_26.c between commit 0d5c6ca30bb0
> ("staging: xgifb: use display information in info not in var for
> panning") from the fbdev tree and commit fd26d42019cb ("staging: xgifb:
> avoid direct references xgi_video_info") from the staging tree.
> 
> I fixed it up (I think - see below) and can carry the fix as necessary.

The fix looks correct to me, thanks.

greg k-h
