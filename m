Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab1EBW2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:28:10 -0400
Received: from zfrontend2.aha.ru ([195.2.83.148]:46712 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757435Ab1EBW2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:28:08 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 2.6.39-rc5-git2 boot crashs
To: Linus Torvalds <torvalds@linux-foundation.org>, jaxboe@fusionio.com,
        tj@kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Mon, 02 May 2011 18:28:05 -0400
Message-ID: <web-516671337@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, with this configuration, sync dont work, the 
terminal waits endless.  And if I type in 'reboot', then 
after the message it would go to reboot, nothing happens 
(it's possible that for reboot, sync is called).
wl
---
Professional hosting for everyone - http://www.host.ru
