Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab2IATbA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 15:31:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:32876 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab2IATa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 15:30:59 -0400
MIME-Version: 1.0
Date: Sat, 1 Sep 2012 12:30:59 -0700
Message-ID: <CALKntY00bG_wVpOGM_L9ENLqROgSO_TttXJeTkgkERdtpnwi_A@mail.gmail.com>
Subject: linux page table
From: Xin Tong <xerox.time.tech@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a process is created in Linux, corresponding page table is
implemented. In the current x86 linux, the page table is a multi-level
page table and CR3 points to the first level of the page table.  I
have 2 questions.

1. is the value in CR3 virtual address or physical address ?
2. can the address of the first level of the page table during a
process's lifetime change ?
3. can two different processes have their CR3 being the same value
even though they have different first level page tables ?

Thanks
