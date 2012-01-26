Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab2AZEAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 23:00:31 -0500
Received: from mail2.nsc.com ([12.238.8.132]:56021 "EHLO sc-mailgw05.nsc.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751630Ab2AZEAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 23:00:30 -0500
X-WSS-ID: 0LYE0GQ-0A-0PG-02
X-M-MSG: 
X-Server-Uuid: 75984BC7-5B1D-45FA-89A9-3E7188D47FBE
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "Anton Vorontsov" <cbouatmailru@gmail.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 Jan 2012 20:00:21 -0800
Subject: [PATCH] power: lp8727_chager: permission change - header file
Thread-Topic: [PATCH] power: lp8727_chager: permission change - header
 file
Thread-Index: Aczb3wX4cJ+6yaqzRZSeTXic76lIQQ==
Message-ID: <B567DBAB974C0544994013492B949F8E3812CD42DD@EXMAIL03.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
MIME-Version: 1.0
X-WSS-ID: 633E10451LS9936019-06-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'x(execute)' permission is removed.
(chmod from 0755 to 0644)

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 0 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 include/linux/lp8727.h

diff --git a/include/linux/lp8727.h b/include/linux/lp8727.h
old mode 100755
new mode 100644
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
Texas Instruments Incorporated

