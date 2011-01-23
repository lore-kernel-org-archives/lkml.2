Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1AWDKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 22:10:36 -0500
Received: from zfrontend1.aha.ru ([195.2.83.147]:46499 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752212Ab1AWDKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 22:10:33 -0500
From: "werner" <w.landgraf@ru.ru>
Subject: 2.6.38-rc1 and -rc2 problems with khugepaged
To: aarcange@redhat.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        idryomov@gmail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <jweiner@redhat.com>
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Sat, 22 Jan 2011 23:10:28 -0400
Message-ID: <web-444847885@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello
I want to inform, still, that with the boot kernel option
transparent_hugepage=never
it dont crash and the computer boots and works normal. I'm 
just now using it with this option.
Thus, the reason for the freezing is really khugepaged.
wl
---
Professional hosting for everyone - http://www.host.ru
