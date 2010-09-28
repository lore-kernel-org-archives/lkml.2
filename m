Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab0I1C5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:57:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40261 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995Ab0I1C5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:57:16 -0400
Date: Tue, 28 Sep 2010 03:57:12 +0100
To: hans-christian.egtvedt@atmel.com
Subject: [patches] avr32 signal fixes
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1P0QNV-0008RZ-1H@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Most of that stuff is quite obvious; the interesting
part is #6; there I'd taken a large chunk out of the asm glue
and hopefully sanitized it into something that just might
work correctly wrt syscall restarts.

