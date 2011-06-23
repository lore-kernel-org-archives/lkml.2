Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599Ab1FWPtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:49:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:31732 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758901Ab1FWPtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:49:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,414,1304319600"; 
   d="scan'208";a="19814189"
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Evgeni Golov <sargentd@die-welt.net>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 Jun 2011 08:49:39 -0700
Subject: RE: [PATCH] iwlagn: fix *_UCODE_API_MAX output in the firmware field
Thread-Topic: [PATCH] iwlagn: fix *_UCODE_API_MAX output in the firmware
 field
Thread-Index: AcwxvM1+ztJY7zurRxKn0m2HF5dw4gAAFN3w
Message-ID: <E9954878DD1FB34FAE5187FB88C58A350198F2C4CD@orsmsx506.amr.corp.intel.com>
References: <1307882071-767-1-git-send-email-sargentd@die-welt.net>
 <1307889852.13397.128.camel@wwguy-huron> <4E034E2B.7000909@die-welt.net>
 <1308840562.13397.271.camel@wwguy-huron>
 <20110623153443.GA2537@tuxdriver.com>
In-Reply-To: <20110623153443.GA2537@tuxdriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_E9954878DD1FB34FAE5187FB88C58A350198F2C4CDorsmsx506amrc_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_E9954878DD1FB34FAE5187FB88C58A350198F2C4CDorsmsx506amrc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable



Wey-Yi Guy
Intel Corporation
2111 N.E. 25th Avenue  M/S JF3-308                =20
Hillsboro OR 97124-5961
USA
Work Phone: 503-264-6023 (OR)
Cell Phone: 503-329-8410
Email: wey-yi.w.guy@intel.com
=20

-----Original Message-----
From: John W. Linville [mailto:linville@tuxdriver.com]=20
Sent: Thursday, June 23, 2011 8:35 AM
To: Guy, Wey-Yi W
Cc: Evgeni Golov; ilw@linux.intel.com; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlagn: fix *_UCODE_API_MAX output in the firmware fie=
ld

On Thu, Jun 23, 2011 at 07:49:22AM -0700, Guy, Wey-Yi wrote:
> On Thu, 2011-06-23 at 07:31 -0700, Evgeni Golov wrote:
> > On 06/12/2011 04:44 PM, Guy, Wey-Yi wrote:
> > > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > >=20
> > > Good catch, thank you very much
> >=20
> > Ping, any plans on merging this? :)
> >=20
>=20
> John, could you merge?
>=20
> Thanks
> Wey

Could someone send me the patch?

John
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

--_002_E9954878DD1FB34FAE5187FB88C58A350198F2C4CDorsmsx506amrc_
Content-Type: message/rfc822

Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 orsmsx601.amr.corp.intel.com (10.22.226.213) with Microsoft SMTP Server (TLS)
 id 8.2.255.0; Sun, 12 Jun 2011 05:35:13 -0700
Received: from rrsmsx602.amr.corp.intel.com (10.31.0.33) by
 ORSMSX151.amr.corp.intel.com (10.22.226.38) with Microsoft SMTP Server (TLS)
 id 14.1.289.1; Sun, 12 Jun 2011 05:35:12 -0700
Received: from azsmga001.ch.intel.com (10.2.17.19) by rrsmsx602-1.rr.intel.com
 (10.31.0.33) with Microsoft SMTP Server id 8.2.255.0; Sun, 12 Jun 2011
 06:35:12 -0600
Received: from azsmga101.ch.intel.com ([10.2.16.36])  by
 azsmga001-1.ch.intel.com with ESMTP; 12 Jun 2011 05:35:11 -0700
Received: from chi.die-welt.net ([84.246.123.210])  by mga03.intel.com with
 ESMTP; 12 Jun 2011 05:35:10 -0700
Received: from localhost (localhost [127.0.0.1])	by chi.die-welt.net (Postfix)
 with ESMTP id 471E363E95;	Sun, 12 Jun 2011 14:35:07 +0200 (CEST)
Received: from chi.die-welt.net ([127.0.0.1])	by localhost (chi.die-welt.net
 [127.0.0.1]) (amavisd-new, port 10024)	with ESMTP id BnheL0oqLQVW; Sun, 12
 Jun 2011 14:35:05 +0200 (CEST)
Received: from dorei.kerker.die-welt.net (ip-62-143-231-6.unitymediagroup.de
 [62.143.231.6])	by chi.die-welt.net (Postfix) with ESMTPSA id 538E063E93;
	Sun, 12 Jun 2011 14:35:05 +0200 (CEST)
From: Evgeni Golov <sargentd@die-welt.net>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>, "ilw@linux.intel.com"
	<ilw@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Evgeni
 Golov <sargentd@die-welt.net>
Date: Sun, 12 Jun 2011 05:34:31 -0700
Subject: [PATCH] iwlagn: fix *_UCODE_API_MAX output in the firmware field
Thread-Topic: [PATCH] iwlagn: fix *_UCODE_API_MAX output in the firmware
 field
Thread-Index: Acwo/S0B8/MdOAW+QM6VHRNoUd7g0Q==
Message-ID: <1307882071-767-1-git-send-email-sargentd@die-welt.net>
X-MS-Exchange-Organization-AuthAs: Anonymous
X-MS-Exchange-Organization-AuthSource: rrsmsx602.amr.corp.intel.com
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ironport-av: E=Sophos;i="4.65,354,1304319600";
    d="scan'208";a="733999533"
x-ironport-anti-spam-filtered: true
x-ironport-anti-spam-result: Av0EADax9E1U9nvS/2dsb2JhbABSpk53yQiGJASZFod9
x-virus-scanned: Debian amavisd-new at chi.die-welt.net
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0

Currently (3.0-rc2), modinfo iwlagn shows:
    firmware:       iwlwifi-5150-IWL5150_UCODE_API_MAX.ucode
    firmware:       iwlwifi-5000-IWL5000_UCODE_API_MAX.ucode
    firmware:       iwlwifi-6000g2b-IWL6000G2_UCODE_API_MAX.ucode
    firmware:       iwlwifi-6000g2a-IWL6000G2_UCODE_API_MAX.ucode
    firmware:       iwlwifi-6050-IWL6050_UCODE_API_MAX.ucode
    firmware:       iwlwifi-6000-IWL6000_UCODE_API_MAX.ucode
    firmware:       iwlwifi-100-IWL100_UCODE_API_MAX.ucode
    firmware:       iwlwifi-1000-IWL1000_UCODE_API_MAX.ucode
    firmware:       iwlwifi-105-IWL105_UCODE_API_MAX.ucode
    firmware:       iwlwifi-2030-IWL2030_UCODE_API_MAX.ucode
    firmware:       iwlwifi-2000-IWL2000_UCODE_API_MAX.ucode

which is obviously wrong, the user should not see the *_UCODE_API_MAX
macros but the actual ucode API versions here.

The problem are the
    #define *_MODULE_FIRMWARE(api) *_FW_PRE #api ".ucode"
which do not expand api correctly (because this is a macro itself).

Fixed by using __stringify() from linux/stringify.h.

Further information about macro stringification can be found here:
    http://gcc.gnu.org/onlinedocs/cpp/Stringification.html

Signed-off-by: Evgeni Golov <sargentd@die-welt.net>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-2000.c |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-6000.c |    9 +++++----
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless=
/iwlwifi/iwl-1000.c
index 61d4a11..2a88e73 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -36,6 +36,7 @@
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
+#include <linux/stringify.h>

 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
@@ -55,10 +56,10 @@
 #define IWL100_UCODE_API_MIN 5

 #define IWL1000_FW_PRE "iwlwifi-1000-"
-#define IWL1000_MODULE_FIRMWARE(api) IWL1000_FW_PRE #api ".ucode"
+#define IWL1000_MODULE_FIRMWARE(api) IWL1000_FW_PRE __stringify(api) ".uco=
de"

 #define IWL100_FW_PRE "iwlwifi-100-"
-#define IWL100_MODULE_FIRMWARE(api) IWL100_FW_PRE #api ".ucode"
+#define IWL100_MODULE_FIRMWARE(api) IWL100_FW_PRE __stringify(api) ".ucode=
"


 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless=
/iwlwifi/iwl-2000.c
index 86feec8..1044309 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -36,6 +36,7 @@
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
+#include <linux/stringify.h>

 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
@@ -58,13 +59,13 @@
 #define IWL105_UCODE_API_MIN 5

 #define IWL2030_FW_PRE "iwlwifi-2030-"
-#define IWL2030_MODULE_FIRMWARE(api) IWL2030_FW_PRE #api ".ucode"
+#define IWL2030_MODULE_FIRMWARE(api) IWL2030_FW_PRE __stringify(api) ".uco=
de"

 #define IWL2000_FW_PRE "iwlwifi-2000-"
-#define IWL2000_MODULE_FIRMWARE(api) IWL2000_FW_PRE #api ".ucode"
+#define IWL2000_MODULE_FIRMWARE(api) IWL2000_FW_PRE __stringify(api) ".uco=
de"

 #define IWL105_FW_PRE "iwlwifi-105-"
-#define IWL105_MODULE_FIRMWARE(api) IWL105_FW_PRE #api ".ucode"
+#define IWL105_MODULE_FIRMWARE(api) IWL105_FW_PRE __stringify(api) ".ucode=
"

 static void iwl2000_set_ct_threshold(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless=
/iwlwifi/iwl-5000.c
index a70b8cf..168153d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -37,6 +37,7 @@
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
+#include <linux/stringify.h>

 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
@@ -57,10 +58,10 @@
 #define IWL5150_UCODE_API_MIN 1

 #define IWL5000_FW_PRE "iwlwifi-5000-"
-#define IWL5000_MODULE_FIRMWARE(api) IWL5000_FW_PRE #api ".ucode"
+#define IWL5000_MODULE_FIRMWARE(api) IWL5000_FW_PRE __stringify(api) ".uco=
de"

 #define IWL5150_FW_PRE "iwlwifi-5150-"
-#define IWL5150_MODULE_FIRMWARE(api) IWL5150_FW_PRE #api ".ucode"
+#define IWL5150_MODULE_FIRMWARE(api) IWL5150_FW_PRE __stringify(api) ".uco=
de"

 /* NIC configuration for 5000 series */
 static void iwl5000_nic_config(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless=
/iwlwifi/iwl-6000.c
index fda6fe0..443a191 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -36,6 +36,7 @@
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
+#include <linux/stringify.h>

 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
@@ -58,16 +59,16 @@
 #define IWL6000G2_UCODE_API_MIN 4

 #define IWL6000_FW_PRE "iwlwifi-6000-"
-#define IWL6000_MODULE_FIRMWARE(api) IWL6000_FW_PRE #api ".ucode"
+#define IWL6000_MODULE_FIRMWARE(api) IWL6000_FW_PRE __stringify(api) ".uco=
de"

 #define IWL6050_FW_PRE "iwlwifi-6050-"
-#define IWL6050_MODULE_FIRMWARE(api) IWL6050_FW_PRE #api ".ucode"
+#define IWL6050_MODULE_FIRMWARE(api) IWL6050_FW_PRE __stringify(api) ".uco=
de"

 #define IWL6005_FW_PRE "iwlwifi-6000g2a-"
-#define IWL6005_MODULE_FIRMWARE(api) IWL6005_FW_PRE #api ".ucode"
+#define IWL6005_MODULE_FIRMWARE(api) IWL6005_FW_PRE __stringify(api) ".uco=
de"

 #define IWL6030_FW_PRE "iwlwifi-6000g2b-"
-#define IWL6030_MODULE_FIRMWARE(api) IWL6030_FW_PRE #api ".ucode"
+#define IWL6030_MODULE_FIRMWARE(api) IWL6030_FW_PRE __stringify(api) ".uco=
de"

 static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 {
--
1.7.2.5


--_002_E9954878DD1FB34FAE5187FB88C58A350198F2C4CDorsmsx506amrc_--
