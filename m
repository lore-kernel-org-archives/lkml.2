Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab2IDRWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 13:22:47 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:42376 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2IDRWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 13:22:45 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: tabloid.adroit@gmail.com
Date: Tue, 4 Sep 2012 13:22:45 -0400
X-Google-Sender-Auth: 6mFGCAdTLpraTU-PBncP2EXWe_Q
Message-ID: <CAJh9x3o=iEJgEGiaf1xACvw3Pd30eYf5jau1yYyKEHTSDYMjKA@mail.gmail.com>
Subject: [perf] how to measure offcore events
From: Yuanfang Chen <cyfmxc@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to measure offcore events
OFFCORE_RESPONSE.ALL_READS.LLC_MISS.DRAM_N (0x3004003F7) using perf
tool. However, I didn't find the way to encode offcore events in
current perf documentation. Can someone help me? Thank you so much.

yuanfang
