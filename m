Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965532Ab2CAV55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:57:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55687 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965262Ab2CAV5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:57:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of xerox.time.tech@gmail.com designates 10.50.15.234 as permitted sender) smtp.mail=xerox.time.tech@gmail.com; dkim=pass header.i=xerox.time.tech@gmail.com
MIME-Version: 1.0
Date: Thu, 1 Mar 2012 16:57:54 -0500
Message-ID: <CALKntY18UnQBbP+ebMtjybpfusWzvrM_EWCynGjLmzBj5adD4g@mail.gmail.com>
Subject: invalidate TLB instruction on x86
From: Xin Tong <xerox.time.tech@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a x86 processor modifies the page table of a running program, it
needs to issue the InvlPg instruction to invalidate the TLB in this
processor. what about TLBs in other processors. are they modified. if
they do, how ?

Thanks


Xin
