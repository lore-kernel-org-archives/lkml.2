Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0LHArA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:47:00 -0500
Received: from kroah.org ([198.145.64.141]:45930 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846Ab0LHAqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:47 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:26 2010
Message-Id: <20101208004426.492640978@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [021/127] hwmon: (lm85) Fix ADT7468 frequency table
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit fa7a5797e57d2ed71f9a6fb44f0ae42c2d7b74b7 upstream.

The ADT7468 uses the same frequency table as the ADT7463.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Darrick J. Wong <djwong@us.ibm.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/lm85.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -1286,6 +1286,7 @@ static int lm85_probe(struct i2c_client
 	switch (data->type) {
 	case adm1027:
 	case adt7463:
+	case adt7468:
 	case emc6d100:
 	case emc6d102:
 		data->freq_map = adm1027_freq_map;


