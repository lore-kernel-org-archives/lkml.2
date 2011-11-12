Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab1KLSII (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 13:08:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35368 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab1KLSIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 13:08:06 -0500
MIME-Version: 1.0
Date: Sat, 12 Nov 2011 13:08:06 -0500
Message-ID: <CALKntY3_YuJxhJX7D5pZhD3pnsoSEz7E60ZTffHyF2W0Hu1fgw@mail.gmail.com>
Subject: Cost of a Page Fault
From: Xin Tong <xerox.time.tech@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All

   My research project in university involves building and using
custom processors as accerlerators. These processors are typically
hooked into the system via a PCIE bus. Applications are compiled with
the custom processor instruction set, when the x86 processor
encounters these extended instructions, it will fault and linux kernel
catches the fault and extract the custom processor instructions. While
extracting the custom processor instructions is not too difficult,
determining what memory the instructions are going to operate on is
hard. One of the ideas I have in mind is by copying the page table of
the faulty process to the custom processor. the custom processor has
its own MMU and when the MMU tries to find a page and the page is not
on the custom processor, it will generate a fault and a dma will be
initiated to copy over the page from system memory.

Therefore, I would like to know the typical time of a dma from system
memory to PCIE. It should be faster than a regular page fault because
regular page fault involves copying from disk which in theory should
be slower than PCIE devices.

Any comments on the cost of page fault and the project in general are
appreciated.

Thanks

Xin
