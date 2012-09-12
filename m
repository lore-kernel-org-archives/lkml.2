Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855Ab2ILRH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:07:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53754 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760761Ab2ILRDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:03:36 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/15] drivers/sbus/char: removes unnecessary semicolon
Date: Wed, 12 Sep 2012 19:03:12 +0200
Message-Id: <1347469402-27557-5-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/sbus/char/display7seg.c |    2 +-
 drivers/sbus/char/envctrl.c     |    8 ++++----
 drivers/sbus/char/openprom.c    |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 4b99397..b160073 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -150,7 +150,7 @@ static long d7s_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			regs |= D7S_FLIP;
 		writeb(regs, p->regs);
 		break;
-	};
+	}
 	mutex_unlock(&d7s_mutex);
 
 	return error;
diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
index 339fd6f..0bc1856 100644
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
@@ -353,7 +353,7 @@ static int envctrl_i2c_data_translate(unsigned char data, int translate_type,
 
 	default:
 		break;
-	};
+	}
 
 	return len;
 }
@@ -644,7 +644,7 @@ envctrl_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	default:
 		break;
 
-	};
+	}
 
 	return ret;
 }
@@ -687,7 +687,7 @@ envctrl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	default:
 		return -EINVAL;
-	};
+	}
 
 	return 0;
 }
@@ -947,7 +947,7 @@ static void envctrl_init_i2c_child(struct device_node *dp,
 
 		default:
 			break;
-		};
+		}
 	}
 }
 
diff --git a/drivers/sbus/char/openprom.c b/drivers/sbus/char/openprom.c
index 2236aea..5843288 100644
--- a/drivers/sbus/char/openprom.c
+++ b/drivers/sbus/char/openprom.c
@@ -222,7 +222,7 @@ static int opromnext(void __user *argp, unsigned int cmd, struct device_node *dp
 		case OPROMSETCUR:
 		default:
 			break;
-		};
+		}
 	} else {
 		/* Sibling of node zero is the root node.  */
 		if (cmd != OPROMNEXT)
@@ -588,7 +588,7 @@ static int openprom_bsd_ioctl(struct file * file,
 	default:
 		err = -EINVAL;
 		break;
-	};
+	}
 	mutex_unlock(&openprom_mutex);
 
 	return err;

