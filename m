Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab0EaTz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:55:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49188 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043Ab0EaTz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:55:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=GD4UK56di8PyMMjMcGE+ueyeuwnSSd7AkqiVq/G6IRsmt0hcRMcRACNX0AlEbvQ+lh
         i7wX66Sjaxzh2FojGRS9m1dBDKquevXScYmaWR1BGtzBCUpmCpH2yukcr09acHF2Voc4
         9lExTItOHc0X10aWqmk/EMejEqGNjALZt4AYA=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [Regression] [2.6.35-rc1] ssb_is_sprom_available
Date: Mon, 31 May 2010 21:55:20 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005312155.20602.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Last known good: 2.6.34
Failing kernel: 2.6.35-rc1

subsystem: PCI, USB(?)

Kernel dies during booting on message "ssb_is_sprom_available", see picture:
http://www.unixy.pl/maciek/download/kernel/2.6.35-rc1/gumis/DSC_0011.JPG

Config:
http://www.unixy.pl/maciek/download/kernel/2.6.35-rc1/gumis/config-2.6.35-rc1

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
