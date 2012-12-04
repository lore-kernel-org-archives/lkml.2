Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab2LDJ3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 04:29:09 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42965 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab2LDJ3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 04:29:05 -0500
Message-ID: <50BDC25C.5020509@suse.cz>
Date: Tue, 04 Dec 2012 10:29:00 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: boyu.mt@taobao.com
CC: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: next: ext4 build failure
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

commit a7b0168d4a9bb78535827ddaf9c055963f5bd7aa
Author: Tao Ma <boyu.mt@taobao.com>
Date:   Sun Dec 2 20:30:52 2012 -0500

    ext4: let fallocate handle inline data correctly

added

static int int ext4_convert_inline_data(struct inode *inode)

       ^^^^^^^

when EXT4_FS_XATTR is unset.

Care to fix that?

thanks,
-- 
js
suse labs
