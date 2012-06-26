Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab2FZVUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 17:20:42 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44627 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2FZVUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 17:20:41 -0400
MIME-Version: 1.0
Date: Tue, 26 Jun 2012 23:20:40 +0200
Message-ID: <CAJiZuY2c1TVVGDxqSDSVC04t5KHK7k=ysJ99Bw6QKvEYdeWO3A@mail.gmail.com>
Subject: kptr_restrict: pK-error in SysRq show-all-timers(Q)
From: Stevie Trujillo <stevie.trujillo@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

if I press ALT+SysRq+Q all the pointers are replaced with "pK-error" like this:
[23153.208033]   .base:               pK-error

with echo h > /proc/sysrq-trigger it works:
[23107.776363]   .base:       ffff88023e60d540

--
Stevie Trujillo
