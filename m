Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0FGBAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 21:00:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49640 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab0FGBAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 21:00:23 -0400
MIME-Version: 1.0
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 7 Jun 2010 03:00:01 +0200
Message-ID: <AANLkTikgWif5ACj4Zm_4eFbx5cAipxMHd5vR4wcYePEZ@mail.gmail.com>
Subject: Unable to boot after "ACPI: Don't let acpi_pad needlessly mark TSC 
	unstable"
To: Venkatesh Pallipadi <venki@google.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Chen Gong <gong.chen@linux.intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venkatesh,

It looks like your commit 0dc698b93f3eecdda43b22232131324eb41e510c
causes init to segfault on one of my computers.

Reverting 0dc698b9 on top of 2.6.35-rc2 solves the problem.

Let me know if you would like more details or if I can help with testing.

Tom
