Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1FXJmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 05:42:36 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:38413 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1FXJme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 05:42:34 -0400
Date: Fri, 24 Jun 2011 02:40:22 -0700 (PDT)
Message-Id: <20110624.024022.829496490655572126.davem@davemloft.net>
To: jj@chaosbits.net
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        sathya.perla@emulex.com, subbu.seetharaman@emulex.com,
        ajit.khaparde@emulex.com, rmody@brocade.com, ddutt@brocade.com,
        sjur.brandeland@stericsson.com, wg@grandegger.com, leedom@chelsio.com,
        xeb@mail.ru, linux-net-drivers@solarflare.com, shodgson@solarflare.com,
        bhutchings@solarflare.com, oliver@neukum.name, gregkh@suse.de,
        Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
Subject: Re: [PATCH 13/37] Remove unneeded version.h includes from
 drivers/net/
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1106240017510.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
	<alpine.LNX.2.00.1106240017510.17688@swampdragon.chaosbits.net>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 24 Jun 2011 02:40:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>
Date: Fri, 24 Jun 2011 00:21:10 +0200 (CEST)

> It was pointed out by 'make versioncheck' that some includes of
> linux/version.h are not needed in drivers/net/.
> This patch removes them.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Applied, thanks.
