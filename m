Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab2LHQ30 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 11:29:26 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49424 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab2LHQ3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 11:29:25 -0500
MIME-Version: 1.0
From: Peng Tao <lkml.bergwolf@gmail.com>
Date: Sun, 9 Dec 2012 00:29:03 +0800
X-Google-Sender-Auth: GAhTURepCgvi0KPGMqZ0W4nzMsk
Message-ID: <CA+a=Yy7_5uSbGZYW=nrj-7q4pSM_t_VSG6fWKACpM1GJtKxcyQ@mail.gmail.com>
Subject: flashcache over md or lvm2?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've seen some problems with flashcache and md/lvm2. When I create
RAID0 with either md or lvm2 and use it as a flashcache
(https://github.com/facebook/flashcache) writeback cache, I noticed
through blktrace that some bio only hit one SSD but not the other.
iostat also confirmed the situation. So I'm wondering if the setup is
even possible?

-- 
Thanks,
-Bergwolf
