Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0G1VUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:20:53 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:59999 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753085Ab0G1VUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:20:50 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Memory corruption during hibernation since 2.6.31
Date: Wed, 28 Jul 2010 23:20:38 +0200
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007282320.39528.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
after very long bisection, I finally found what's causing memory corruption 
during hibernation on my machine sice 2.6.31:
https://bugzilla.kernel.org/show_bug.cgi?id=15753

It's commit c9e444103b5e7a5a3519f9913f59767f92e33baf (mm: reuse unused swap 
entry if necessary).

I don't know anything about swapping in Linux so I don't have a clue what's
wrong with that commit.

-- 
Ondrej Zary
