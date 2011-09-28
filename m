Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1I1WxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:53:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933553Ab1I1Wup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:50:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:51 2011
Message-Id: <20110928220150.996452248@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Kravkov <dmitry@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [243/244] bnx2x: add missing break in bnx2x_dcbnl_get_cap
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Shmulik Ravid <shmulikr@broadcom.com>

commit a0babc80eb375aad69dab4687c3b44c47d42f241 upstream.

Signed-off-by: Dmitry Kravkov <dmitry@broadcom.com>
Signed-off-by: Eilon Greenstein <eilong@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bnx2x/bnx2x_dcb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/bnx2x/bnx2x_dcb.c
+++ b/drivers/net/bnx2x/bnx2x_dcb.c
@@ -1858,6 +1858,7 @@ static u8 bnx2x_dcbnl_get_cap(struct net
 			break;
 		case DCB_CAP_ATTR_DCBX:
 			*cap = BNX2X_DCBX_CAPS;
+			break;
 		default:
 			rval = -EINVAL;
 			break;


