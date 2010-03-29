Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab0C2IjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 04:39:16 -0400
Received: from mail-ew0-f222.google.com ([209.85.219.222]:33390 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab0C2IjO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 04:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=AMRF4oAD2CY3Lbp0X+XcsMTgghmf1MU39012wmbd54y1WSiSaMtTjjfeqc5M+t8D8K
         4y9XAkjQheH6vFwAzJlcmC2qnB6jGUu4g9VKS4Cm5CTakciio50HWGZEr5kat8Rfs82b
         penr3xGIrVjRjMPaNUDWixAd4cmE/yReNq1Sc=
MIME-Version: 1.0
Date: Mon, 29 Mar 2010 10:39:12 +0200
Message-ID: <a3177ec71003290139w3f435bddv25e06a576afabb07@mail.gmail.com>
Subject: [PATCH] /fs/cifs HEAD
From: Timo Witte <timo.witte@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 4baf102b1db4ba5c91532acf84acdb9c31867fe6
Author: Timo Witte <timo.witte@googlemail.com>
Date:   Mon Mar 29 10:20:09 2010 +0200
    added additional info to error message in cifs
diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index 8794814..28b588c 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -137,7 +137,7 @@ dns_resolve_server_name_to_ip(const char *unc,
char **ip_addr)
                len = rkey->type_data.x[0];
                data = rkey->payload.data;
        } else {
-               cERROR(1, ("%s: unable to resolve: %s", __func__, name));
+              cERROR(1, ("%s: unable to resolve: %s have you
installed /sbin/request-key ?", __func__, name));
                goto out;
        }
