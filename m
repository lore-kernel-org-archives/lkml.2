Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2HaJXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:23:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37504 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2HaJWw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:22:52 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/22] lp8727_charger: clean up code
Thread-Topic: [PATCH 00/22] lp8727_charger: clean up code
Thread-Index: Ac2HWiTGzGSZWrkyT6muTzV78e5bWQ==
Date: Fri, 31 Aug 2012 09:22:39 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF1E58@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LP8727 driver should be fixed for several reasons.

(a) Need to clean up _probe() and _remove()
(b) Not secure code when the platform data is NULL
(c) Improved the interrupt handling
(d) Lots of definitions should be unique.
(e) Others...

Patch v2.
These patches are submitted more separately.

[PATCH 01/22] lp8727_charger: use devm_kzalloc()
[PATCH 02/22] lp8727_charger: cleanup _probe() and _remove()
[PATCH 03/22] lp8727_charger: fix buggy code of NULL pdata
[PATCH 04/22] lp8727_charger: add configurable debouce timer
[PATCH 05/22] lp8727_charger: remove unnecessary workqueue thread
[PATCH 06/22] lp8727_charger: clean up the interrupt handler
[PATCH 07/22] lp8727_charger: clear interrrupts at inital time
[PATCH 08/22] lp8727_charger: fix code for getting battery temp
[PATCH 09/22] lp8727_charger: use the definition rather than enum
[PATCH 10/22] lp8727_charger: clean up lp8727 definitions
[PATCH 11/22] lp8727_charger: use specific definition
[PATCH 12/22] lp8727_charger: clean up lp8727_is_charger_attached()
[PATCH 13/22] lp8727_charger: make lp8727_init_device() shorter
[PATCH 14/22] lp8727_charger: make lp8727_ctrl_switch() inline
[PATCH 15/22] lp8727_charger: make lp8727_charger_get_propery() simpler
[PATCH 16/22] lp8727_charger: return if the battery is discharging
[PATCH 17/22] lp8727_charger: clean up lp8727_charger_changed()
[PATCH 18/22] lp8727_charger: make cosmetic code on lp8727_delayed_func()
[PATCH 19/22] lp8727_charger: fix typo - chg_parm to chg_param
[PATCH 20/22] lp8727_charger: add description in the private data
[PATCH 21/22] lp8727_charger: fix checkpatch warning
[PATCH 22/22] lp8727_charger: make cosmetic code


Best Regards,
Milo


