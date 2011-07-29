Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1G2HrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 03:47:25 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61305 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab1G2HrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 03:47:24 -0400
MIME-Version: 1.0
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 29 Jul 2011 00:47:03 -0700
Message-ID: <CAMjpGUejy+p2+86DT8-LDMzWYxKKBp=2SQTNZ=7KaFoPMRiJ4A@mail.gmail.com>
Subject: atomic_set_mask duplication
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seems that my atomic_set_mask() patch for asm-generic/atomic.h has
made it into linux-next but duplicated ?  any idea what's going on ?

commit 00b3c28bd753 is correct.  but then we also have 49472be55954
which should not exist ...
-mike
