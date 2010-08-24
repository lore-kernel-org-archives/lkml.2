Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368Ab0HXXoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:44:21 -0400
Received: from kroah.org ([198.145.64.141]:52209 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932441Ab0HXWyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:54:03 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:25:25 2010
Message-Id: <20100824222525.085037995@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:24:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [31/59] sparc64: Add missing ID to parport probing code.
In-Reply-To: <20100824224625.GA5449@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit bf8253bf5e7cfe17dd53e3f6340a45b11d9fb51c ]

SunBlade-2500 has 'parallel' device node with compatible
property "pnpALI,1533,3" so add that to the ID table.

Reported-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/include/asm/parport.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/sparc/include/asm/parport.h
+++ b/arch/sparc/include/asm/parport.h
@@ -228,6 +228,10 @@ static const struct of_device_id ecpp_ma
 		.name = "parallel",
 		.compatible = "ns87317-ecpp",
 	},
+	{
+		.name = "parallel",
+		.compatible = "pnpALI,1533,3",
+	},
 	{},
 };
 


