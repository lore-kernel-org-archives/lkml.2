Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1AUKnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 05:43:50 -0500
Received: from zfrontend2.aha.ru ([195.2.83.148]:48727 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750844Ab1AUKnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 05:43:49 -0500
From: "werner" <w.landgraf@ru.ru>
Subject: 2.6.38-rc1 problems with khugepaged
To: akpm@linux-foundation.org, hannes@cmpxchg.org, aarcange@redhat.com,
        idryomov@gmail.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, torvalds@linux-foundation.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Fri, 21 Jan 2011 06:43:44 -0400
Message-ID: <web-444048714@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-rc1-git1 runs normally with khugepaged switched 
OFF.  Thus, khugepaged  is the problem; as said if 
switched it on, during boot the computer becomes very slow 
and sticks almost.    wl
---
Professional hosting for everyone - http://www.host.ru
