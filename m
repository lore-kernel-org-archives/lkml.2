Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab0G2FNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 01:13:55 -0400
Received: from imr3.ericy.com ([198.24.6.13]:45805 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab0G2FNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 01:13:53 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: Jean Delvare <khali@linux-fr.org>, Dmitry Torokhov <dtor@mail.ru>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jani Nikula <ext-jani.1.nikula@nokia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Nick Cheng <nick.cheng@areca.com.tw>,
        James Smart <james.smart@emulex.com>,
        Alex Iannicelli <alex.iannicelli@emulex.com>,
        "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        Benjamin Thery <benjamin.thery@bull.net>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH 6/6] Remove owner field from sysfs struct attribute
Date: Wed, 28 Jul 2010 22:09:26 -0700
Message-ID: <1280380166-29196-7-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
References: <1280380166-29196-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
 include/linux/sysfs.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index f2694eb..880fa1a 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -22,14 +22,8 @@ struct kobject;
 struct module;
 enum kobj_ns_type;
 
-/* FIXME
- * The *owner field is no longer used.
- * x86 tree has been cleaned up. The owner
- * attribute is still left for other arches.
- */
 struct attribute {
 	const char		*name;
-	struct module		*owner;
 	mode_t			mode;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lock_class_key	*key;
-- 
1.7.0.87.g0901d

