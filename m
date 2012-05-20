Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2ETLf3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 07:35:29 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:42956
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752936Ab2ETLf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 07:35:28 -0400
Date: Sun, 20 May 2012 13:35:26 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [patch] UBIFS: improved comment for data node's format history
In-Reply-To: <1337427288.2041.24.camel@koala>
Message-ID: <alpine.DEB.2.00.1205201334080.26953@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205151101100.17750@eristoteles.iwoars.net>  <1337087022.2528.204.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1205161451250.27131@eristoteles.iwoars.net>  <alpine.DEB.2.00.1205191027340.18672@eristoteles.iwoars.net>
 <1337427288.2041.24.camel@koala>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few more lines of comment on ksa_pos field in struct ubifs_data_node.

Signed-off-by: Joel Reardon <reardonj@inf.ethz.ch>
---
 fs/ubifs/ubifs-media.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/ubifs-media.h b/fs/ubifs/ubifs-media.h
index 55f2ccd..90f348c 100644
--- a/fs/ubifs/ubifs-media.h
+++ b/fs/ubifs/ubifs-media.h
@@ -545,6 +545,11 @@ struct ubifs_dent_node {
  * @padding: reserved for future, zeroes
  * @data: data
  *
+ * The @ksa_pos value is used for secure deletion enhancement of UBIFS.
+ * In older versions of UBIFS, @ksa_pos did not exist but was instead an
+ * unused part of @key and was set to all zeros. UBIFS partitions with secure
+ * deletion disabled also store all zeros for ksa_pos.
+ *
  * Note, do not forget to amend 'zero_data_node_unused()' function when
  * changing the padding fields.
  */
-- 
1.7.5.4


