Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab1KMA7q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 19:59:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35402 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1KMA7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 19:59:45 -0500
MIME-Version: 1.0
Date: Sat, 12 Nov 2011 19:59:44 -0500
Message-ID: <CALKntY3ivYxMzuaq0BwXO_uX=w+_wneaNV6zCGo0ZeAZWm54Sw@mail.gmail.com>
Subject: INVLPG Instruction
From: Xin Tong <xerox.time.tech@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

  When a process has a page fault and Linux swaps out a page ( no more
free page ) from another process and give it to the page-faulting
process. Typically a INVLPG is used to invalidate entries  in the TLB.
I would like to know whether INVLPG is global ( i.e. across all cores
)? How does the process which Linux stole the page from get informed (
how is its tlb invalidated) ?

Thanks
