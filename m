Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161Ab1D2U6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:58:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38167
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889Ab1D2U6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:58:19 -0400
Date: Fri, 29 Apr 2011 13:57:45 -0700 (PDT)
Message-Id: <20110429.135745.258121929.davem@davemloft.net>
To: artpol84@gmail.com
Cc: linux-kernel@vger.kernel.org, bhutchings@solarflare.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.38.4] mii: add support of pause frames in mii_get_an
From: David Miller <davem@davemloft.net>
In-Reply-To: <1303962554.15395.1.camel@artpol-thinkpad>
References: <1303962554.15395.1.camel@artpol-thinkpad>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: artpol <artpol84@gmail.com>
Date: Thu, 28 Apr 2011 10:49:14 +0700

> Add support of pause frames advertise in mii_get_an. This provides all drivers 
> that use mii_ethtool_gset to represent their own and Link partner flow control
> abilities in ethtool.
> 
> Signed-off-by: Artem Polyakov <artpol84@gmail.com>

Applied, thanks.
