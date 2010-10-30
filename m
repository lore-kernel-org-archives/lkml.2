Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab0J3VPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:15:52 -0400
Received: from mail.perches.com ([173.55.12.10]:3730 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423Ab0J3VJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:29 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 10/39] drivers/firewire: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:27 -0700
Message-Id: <0da8d9f6ec1e995cabc26bad95c03b857f39cbb7.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing newlines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/firewire/core-transaction.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
index b42a0bd..ad864d8 100644
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -250,7 +250,7 @@ static void fw_fill_request(struct fw_packet *packet, int tcode, int tlabel,
 		break;
 
 	default:
-		WARN(1, "wrong tcode %d", tcode);
+		WARN(1, "wrong tcode %d\n", tcode);
 	}
  common:
 	packet->speed = speed;
@@ -638,7 +638,7 @@ int fw_get_response_length(struct fw_request *r)
 		}
 
 	default:
-		WARN(1, "wrong tcode %d", tcode);
+		WARN(1, "wrong tcode %d\n", tcode);
 		return 0;
 	}
 }
@@ -694,7 +694,7 @@ void fw_fill_response(struct fw_packet *response, u32 *request_header,
 		break;
 
 	default:
-		WARN(1, "wrong tcode %d", tcode);
+		WARN(1, "wrong tcode %d\n", tcode);
 	}
 
 	response->payload_mapped = false;
-- 
1.7.3.1.g432b3.dirty

