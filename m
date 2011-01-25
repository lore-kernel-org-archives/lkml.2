Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab1AYNEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 08:04:37 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36351 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1AYNEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 08:04:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=gVSxnf3AzokwMnJiAExxcEU3NQF6b0tCRppMl8p8u1oM1QI6OBVzRtExo0/ml6tn80
         8VdVZzVtM715Q57Wxa3OWUFIkj/bOV9afGjLnGaEjxp8pJdb/evRbJPidtQHLB7kxfwo
         ZFidUU+hztm5HHT5asUh2bXLOF68vKVyMRCjA=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 00/11] staging: ft1000: Various coding style cleanups.
Date: Tue, 25 Jan 2011 14:04:55 +0100
Message-Id: <1295960706-15667-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1..v2:
- remove patch - staging: ft1000: Use common return point
- fix various alignment problems in patches:
Fix coding style in get_handshake_usb() function.
Fix coding style in get_request_type() function.
Fix coding style in get_request_type_usb() function.
Fix coding style in get_request_value() function.

Marek Belisko (11):
  staging: ft1000: Remove dead code.
  staging: ft1000: Fix coding style in check_usb_db() function.
  staging: ft1000: Fix coding style in put_handshake() function.
  staging: ft1000: Fix coding style in get_handshake_usb() function.
  staging: ft1000: Fix coding style in put_handshake_usb() function.
  staging: ft1000: Fix coding style in get_request_type() function.
  staging: ft1000: Fix coding style in get_request_type_usb() function.
  staging: ft1000: Fix coding style in get_request_value() function.
  staging: ft1000: Fix coding style in put_request_value() function.
  staging: ft1000: Fix coding style in hdr_checksum() function.
  staging: ft1000: Fix coding style in get_handshake() function.

 .../staging/ft1000/ft1000-usb/ft1000_download.c    |  487 ++++++++------------
 1 files changed, 204 insertions(+), 283 deletions(-)

