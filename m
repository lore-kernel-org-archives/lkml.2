Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781Ab0HNRom (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 13:44:42 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:59404 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab0HNRol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 13:44:41 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Andreas Gruenbacher <agruen@suse.de>
Subject: struct fanotify_event_metadata
CC: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org
X-Yow: How do you explain Wayne Newton's POWER over millions?
 It's th' MOUSTACHE...  Have you ever noticed th' way it radiates
 SINCERITY, HONESTY & WARMTH?  It's a MOUSTACHE you want to take
 HOME and introduce to NANCY SINATRA!
Date: Sat, 14 Aug 2010 19:44:38 +0200
Message-ID: <m21va1ozqx.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pid field of struct fanotify_event_metadata has 64 bits which looks
excessive.  Wouldn't it make sense to make it 32 bits and swap it with
the mask field?  That would avoid the unaligned mask field, and remove
the need for the packed attribute.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
