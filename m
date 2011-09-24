Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab1IXNky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 09:40:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55374 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab1IXNkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 09:40:53 -0400
MIME-Version: 1.0
Date: Sat, 24 Sep 2011 21:40:52 +0800
Message-ID: <CAOkaeLJTeewFWpHCVBqNwmuL7nEbFYnrQ86SQOO7fVg_Uc3Q4Q@mail.gmail.com>
Subject: Seems the comment of find_next_system_ram() is not exact
From: Wizard <wizarddewhite@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Experts

I am a newbie for linux kernel. I just read the code of
find_next_system_ram() in kernel/resource.c

I think the comment of this function is not exact. This says "Finds
the lowest memory reosurce exists within [res->start.res->end)".

While I think the code is to find the lowest memory resource overlaps
[res->start, res->end).

308:      if ((p->end >= start) && (p->start < end))

If I am not correct, please let me know. :)

BTW, I find the "reosurce" is a typo.

-- 
Wizard
