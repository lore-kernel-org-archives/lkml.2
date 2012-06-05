Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2FERjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:39:40 -0400
Received: from www.piware.de ([213.9.93.70]:59812 "EHLO mail.piware.de"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab2FERjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:39:39 -0400
Date: Tue, 5 Jun 2012 19:39:30 +0200
From: Martin Pitt <martin.pitt@ubuntu.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Zeuthen <zeuthen@gmail.com>, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH 1/1] [SCSI] scsi_debug: Add "removable" parameter
Message-ID: <20120605173930.GO3043@piware.de>
References: <20120605072528.GE3043@piware.de>
 <20120605072737.GF3043@piware.de>
 <4FCE30DE.6090903@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FCE30DE.6090903@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap [2012-06-05  9:16 -0700]:
> so why not make it a bool instead of an int value?

Just like the obsolete printk KERN_ERR and the overly long lines (see
my intro mail) I wanted to be consistent with the existing boolean
options (the other flags also use an int).

However, I don't mind much either way; if it is preferred, I can
send a patch with int → bool.

Thanks,

Martin

-- 
Martin Pitt                        | http://www.piware.de
Ubuntu Developer (www.ubuntu.com)  | Debian Developer  (www.debian.org)
