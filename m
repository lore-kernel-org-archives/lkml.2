Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab0EKSJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:09:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41098 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890Ab0EKSJL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:09:11 -0400
From: "Arce, Abraham" <x0066660@ti.com>
To: "trivial@kernel.org" <trivial@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "khali@linux-fr.org" <khali@linux-fr.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "bgardner@wabtec.com" <bgardner@wabtec.com>
Date: Tue, 11 May 2010 13:08:03 -0500
Subject: [PATCH 0/3] EEPROM: Clean up headers in files
Thread-Topic: [PATCH 0/3] EEPROM: Clean up headers in files
Thread-Index: AcrxNOYIBiETXGBWRPu4lrdPcmVGmQ==
Message-ID: <27F9C60D11D683428E133F85D2BB4A53043DFD5807@dlee03.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the top header of the required files under driver/misc/eeprom
directory to follow the comment guidelines.

These patches are against trivial/for-next.

--

[PATCH] EEPROM: Header file cleanup
[PATCH] EEPROM: 93cx6: Header file cleanup
[PATCH] EEPROM: max6875: Header file cleanup

--
 
 eeprom.c       |   40 ++++++++++++++++++++--------------------
 eeprom_93cx6.c |   44 +++++++++++++++++++++-----------------------
 max6875.c      |   52 ++++++++++++++++++++++++++--------------------------
 3 files changed, 67 insertions(+), 69 deletions(-)
