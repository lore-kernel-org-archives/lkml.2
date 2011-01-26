Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1AZJ51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 04:57:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:22436 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab1AZJ5Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 04:57:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,379,1291622400"; 
   d="scan'208";a="596584887"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Bob Liu <lliubbo@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
        "Winkler, Tomas" <tomas.winkler@intel.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "gregkh@suse.de" <gregkh@suse.de>
Date: Wed, 26 Jan 2011 09:56:56 +0000
Subject: RE: [PATCH] firmware_classs: change val uevent's type to bool
Thread-Topic: [PATCH] firmware_classs: change val uevent's type to bool
Thread-Index: Acu9Px2vr085tGJeSkGNolWqSUcRiwAAD/oy
Message-ID: <C5C86A19469DAE48AAAD0E5F3716E44501D6329793@irsmsx504.ger.corp.intel.com>
References: <1296036004-15644-1-git-send-email-lliubbo@gmail.com>
In-Reply-To: <1296036004-15644-1-git-send-email-lliubbo@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@@ -463,7 +463,8 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
        f_dev->parent = device;
        f_dev->class = &firmware_class;

-       dev_set_uevent_suppress(f_dev, true);
+       if (uevent)
+               dev_set_uevent_suppress(f_dev, true);

Everything but this is a no-op basically, but you didn't even describe this change?

johannes
--------------------------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland 
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052

