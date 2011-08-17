Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab1HQGsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 02:48:11 -0400
Received: from zfrontend1.aha.ru ([195.2.83.147]:36614 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751277Ab1HQGsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 02:48:07 -0400
X-Greylist: delayed 3603 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Aug 2011 02:48:06 EDT
From: "werner" <w.landgraf@ru.ru>
Subject: 3.1-rc2 boot crashs
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Wed, 17 Aug 2011 01:47:58 -0400
Message-ID: <web-589640183@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-rc1 and 2 crash during boot, within 1 sec after 
starting (screen stays black, harddisk lamp stops to 
blink, no error messg obtainable). That's with the allyes 
config, which with 3.0.1 , 3.0.2 don't have any problems 
(3.0.2 i compiled today too and it runs normally).  To 
avoid that this problem continues long time until 
corrected, I advice, although I cannot help with an error 
message.  Who want can give me suggestions what to 
disable.
wl
---
Professional hosting for everyone - http://www.host.ru
