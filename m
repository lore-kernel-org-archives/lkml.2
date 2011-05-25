Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab1EYDOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 23:14:21 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:53745 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753979Ab1EYDOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 23:14:20 -0400
Date: Wed, 25 May 2011 04:14:17 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Squashfs updates
Message-ID: <4ddc7409.S8oDi7GkNvO2vzj7%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches add some extra superblock sanity checks
at mount time.  This fixes a number of fsfuzzer corrupted filesystem
warn_ons.

It should also mean more filesystem corruption is detected at
mount time, avoiding the case where the mount succeeds, but all
file/dentry operations results in screen fulls of errors.

Phillip


