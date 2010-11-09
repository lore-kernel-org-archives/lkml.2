Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab0KIPRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:17:47 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:38986 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702Ab0KIPRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:17:43 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 00/11] hwmon: applesmc: Dynamic configuration rewrite (rev2)
Date: Tue,  9 Nov 2010 16:15:00 +0100
Message-Id: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PFpvV-00011c-CG.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PFpvV-00011c-CG 2533352b8e0f7011239bd4655e1b072d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is revision two of the applesmc makeover. All comments from
Guenter have been addressed. In this set, I have put the candidates
for stable first, therefore the patch from Joe is also included (with
one hunk removed).  There is also one additional janitory patch at the
end, saluting the silent kernel.

Regarding the changes, there should be no big surprises. The comment
about reading six and using five was particularly useful; it turns out
the missing byte is a useful attribute field. Thanks!

The patches are available in the applesmc-dkms package, and are
already in use by a measurable portion of the mactel users.

Cheers,
Henrik

Edgar Hucek (1):
  hwmon: applesmc: Add MacBookAir3,1(3,2) support

Henrik Rydberg (9):
  hwmon: applesmc: Relax the severity of device init failure (rev2)
  hwmon: applesmc: Introduce a register lookup table (rev2)
  hwmon: applesmc: Dynamic creation of temperature files (rev2)
  hwmon: applesmc: Handle new temperature format (rev2)
  hwmon: applesmc: Extract all features generically (rev2)
  hwmon: applesmc: Dynamic creation of fan files (rev2)
  hwmon: applesmc: Simplify feature sysfs handling (rev2)
  hwmon: applesmc: Silence driver
  hwmon: applesmc: Update copyright information

Joe Perches (1):
  drivers/hwmon/applesmc.c: Use pr_fmt and pr_<level>

 drivers/hwmon/applesmc.c | 1591 ++++++++++++++++------------------------------
 1 files changed, 549 insertions(+), 1042 deletions(-)

