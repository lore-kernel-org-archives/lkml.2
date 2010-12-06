Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0LFPH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:07:28 -0500
Received: from nm4.bullet.mail.in.yahoo.com ([121.101.151.226]:24644 "HELO
	nm4.bullet.mail.in.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751822Ab0LFPH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:07:27 -0500
X-Yahoo-Newman-Id: 347408.47586.bm@omp1004.mail.in.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=DKIM-Signature:Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Content-Disposition:User-Agent;
  b=S6k7d0FwOH5idUE70y9Bc4U2AjvOnS1c3YVDcgJRXcY/KS9AYSsP4z0IYlOwkE94P8Ih9waKuajtFUuHQDH9tQu3Zsn+klDJesjkQ6f0ZQblCDv4AcW41M3/kMcEUY8u5SbCR4cuGWFOJ92ivJWFlk/xtALFf8NAPLjtnjArd8o=  ;
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
X-YMail-OSG: bpFmWcUVM1k8nkbuz9b4h1UGiS9rofCj2wmd0w1s9L4vB9K
 65nFfavY424Q07qhGqrmzUiZuveAscXiINsz3XLx5snMRigEP8e2H0IAzLYl
 ga7TStq6PQPj0hXAEC6zG1tZ.8IGOV4koavTutL9ZPS9GUzxBSVsxeX8d86w
 SM2MvNWsdMogXgIQJ8.IoYHyqDlqKnHvs3QdbVYEaCNDkJIlssyPzzlgFgBG
 .JpP6uJQ.z.9gYQwQLUYpgV53sFz9oSNpXbdo.bRfuF2lVa8xgdFUplA72vL
 rNAWBn0iT3E7G6w--
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 6 Dec 2010 20:37:24 +0530
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: sound: Fixed line limit issue in sound/ac97_bus.c
Message-ID: <20101206150724.GA2752@debian.Jeff>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hello.
a small patch for a format issue is attached with this
mail.
-- 
software engineer.
department of computer science
rajagiri school of engineering and technology.

--fdj2RfSjLxBAspz7
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-sound-Fixed-line-limit-issue-in-sound-ac97_bus.c.patch"

>From a2c2867876c246420a199a0fb4c36ad2965a42cc Mon Sep 17 00:00:00 2001
From: Jeffrin Jose <ahiliation@yahoo.co.in>
Date: Mon, 6 Dec 2010 19:27:53 +0530
Subject: [PATCH] sound: Fixed line limit issue in sound/ac97_bus.c
 This is a patch to the sound/ac97_bus.c file that fixes up a 80 character
 line limit issue found by the checkpatch.pl tool.
 Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>

---
 sound/ac97_bus.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/ac97_bus.c b/sound/ac97_bus.c
index a351dd0..c93251a 100644
--- a/sound/ac97_bus.c
+++ b/sound/ac97_bus.c
@@ -19,9 +19,9 @@
 
 /*
  * Let drivers decide whether they want to support given codec from their
- * probe method.  Drivers have direct access to the struct snd_ac97 structure and may
- * decide based on the id field amongst other things.
- */
+ * probe method. Drivers have direct access to the struct snd_ac97
+ * structure and may  decide based on the id field amongst other things.
+*/
 static int ac97_bus_match(struct device *dev, struct device_driver *drv)
 {
 	return 1;
-- 
1.7.1


--fdj2RfSjLxBAspz7--
