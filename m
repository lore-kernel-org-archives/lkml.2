Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab1JMGMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 02:12:36 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:35298 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423Ab1JMGMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 02:12:34 -0400
X-Sasl-enc: uEdkjMnmwDlAay5KPfRuxexjIigFNRFoMR17Jtb7K58q 1318486353
Date: Thu, 13 Oct 2011 00:12:23 -0600
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arend van Spriel <arend@broadcom.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jpirko@redhat.com>, Eliad Peller <eliad@wizery.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: manual merge of the staging tree with the net tree
Message-ID: <20111013061223.GC23172@kroah.com>
References: <20111013164353.09c495e1b63d23e380cca1f7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111013164353.09c495e1b63d23e380cca1f7@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 04:43:53PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflicts in
> drivers/staging/brcm80211/brcmfmac/dhd_linux.c and
> drivers/staging/brcm80211/brcmsmac/mac80211_if.c between commits from the
> net-next tree and commit fc2d6e573be6 ("staging: brcm80211: remove
> brcm80211 driver from the staging tree") from the staging tree.
> 
> The latter removed the files, so I did that

Wonderful, thanks for doing that.

greg
