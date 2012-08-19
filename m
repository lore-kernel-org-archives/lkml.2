Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab2HSOjr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 10:39:47 -0400
Received: from zfrontend2.aha.ru ([195.2.83.148]:39541 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751743Ab2HSOjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 10:39:45 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 3.6-rc2 crashs often with keyboard blinking
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Sun, 19 Aug 2012 10:39:38 -0400
Message-ID: <web-782181085@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-rc2 crashs often (not during the boot, but later when 
using KDE and internet)
Then the keyboard is blinking, sometimes 2, sometimes 3 
lamps (Caps Lock, Scroll lock, sometimes Num Lock too)
With 3.6-rc2 this didn't happen.   The configuration stays 
the same.
In the logfiles is nothing visible.
Ideas how to catch this ?
---
Professional hosting for everyone - http://www.host.ru
