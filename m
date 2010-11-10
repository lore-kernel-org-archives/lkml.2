Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0KJKcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 05:32:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab0KJKcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 05:32:43 -0500
From: Andreas Schwab <schwab@redhat.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: <linux-kernel@vger.kernel.org>, joe@perches.com,
        hirofumi@mail.parknet.co.jp
Subject: Re: [PATCH 1/4] Convert fat_fs_error to use %pV
References: <1289331805.28590.17.camel@Joe-Laptop>
	<1289384592-4881-1-git-send-email-bug-track@fisher-privat.net>
X-Yow: If this is the DATING GAME I want to know your FAVORITE PLANET!  Do I
 get th' MICROWAVE MOPED?
Date: Wed, 10 Nov 2010 11:32:35 +0100
In-Reply-To: <1289384592-4881-1-git-send-email-bug-track@fisher-privat.net>
	(Alexey Fisher's message of "Wed, 10 Nov 2010 11:23:09 +0100")
Message-ID: <m3pqudsc3g.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Fisher <bug-track@fisher-privat.net> writes:

> - be consequent and use "supor_block *sb" instead of "supor_block *s"

s/supor/super/

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
