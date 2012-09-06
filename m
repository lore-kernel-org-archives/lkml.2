Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab2IFQMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:12:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36539 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546Ab2IFQJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:09:44 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/10] drivers/media/radio/si4713-i2c.c: removes unnecessary semicolon
Date: Thu,  6 Sep 2012 18:09:11 +0200
Message-Id: <1346947757-10481-4-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1346947757-10481-1-git-send-email-peter.senna@gmail.com>
References: <1346947757-10481-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/radio/si4713-i2c.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -u -p a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -1009,7 +1009,7 @@ static int si4713_choose_econtrol_action
 
 	default:
 		rval = -EINVAL;
-	};
+	}
 
 	return rval;
 }
@@ -1081,7 +1081,7 @@ static int si4713_write_econtrol_string(
 	default:
 		rval = -EINVAL;
 		break;
-	};
+	}
 
 exit:
 	return rval;
@@ -1130,7 +1130,7 @@ static int si4713_write_econtrol_tune(st
 	default:
 		rval = -EINVAL;
 		goto unlock;
-	};
+	}
 
 	if (sdev->power_state)
 		rval = si4713_tx_tune_power(sdev, power, antcap);
@@ -1420,7 +1420,7 @@ static int si4713_read_econtrol_string(s
 	default:
 		rval = -EINVAL;
 		break;
-	};
+	}
 
 exit:
 	return rval;
@@ -1473,7 +1473,7 @@ static int si4713_read_econtrol_tune(str
 		break;
 	default:
 		rval = -EINVAL;
-	};
+	}
 
 unlock:
 	mutex_unlock(&sdev->mutex);
@@ -1698,7 +1698,7 @@ static int si4713_queryctrl(struct v4l2_
 	default:
 		rval = -EINVAL;
 		break;
-	};
+	}
 
 	return rval;
 }

