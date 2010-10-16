Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab0JPRmL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 13:42:11 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34477 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072Ab0JPRmJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 13:42:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=f0uVOkC8Hu0BxXBySbFNPlyTXzArMsm2935l3i8Ba3Z5r8COOEMSsJknpj24lU+ln4
         zfeIXI+AXx3Dspf0ZgQiZoN3qwikdXSIpnLlssdd4Aw1y9JUM08Z716VntY/0jdlkFk0
         Yve7+KMPry89kAjFzlrCpreFYch2+7A+Sw/LQ=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [2.6.36-rc8] ERROR: "dump_write" [fs/binfmt_aout.ko] undefined!
Date: Sat, 16 Oct 2010 19:42:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7; KDE/4.4.5; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010161942.03081.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all

During compiling 2.6.36-rc8:
CC [M]  net/wireless/wext-compat.o
  CC [M]  net/wireless/wext-sme.o
  CC [M]  net/wireless/lib80211.o
  LD [M]  net/wireless/cfg80211.o
  Building modules, stage 2.
  MODPOST 344 modules
ERROR: "dump_write" [fs/binfmt_aout.ko] undefined!
ERROR: "dump_seek" [fs/binfmt_aout.ko] undefined!
make[2]: *** [__modpost] Błąd 1
make[1]: *** [modules] Błąd 2
make[1]: Opuszczenie katalogu `/usr/src/linux-2.6.36-rc8'
make: *** [debian/stamp/build/kernel] Błąd 2

Three different machines (laptop, PC and virtualbox), the same problem.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
