Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2GWPzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:55:49 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231Ab2GWPzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:55:48 -0400
Message-ID: <500D73FF.1070504@nod.at>
Date: Mon, 23 Jul 2012 17:55:43 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: linux-fsdevel@vger.kernel.org, linux-man@vger.kernel.org
Subject: st_size of a symlink
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

lstat(2) on /proc/$pid/exe gives me a stat object where st_size is 0.

Or:
rw@mantary:~> ls -l /proc/$$/exe
lrwxrwxrwx 1 rw users 0 23. Jul 17:02 /proc/16902/exe -> /bin/bash

The lstat(2) manpage says:
"The st_size field gives the size of the file (if it is a regular file 
or a symbolic link) in bytes.  The size of a symbolic link is the length 
of the pathname it contains, without a terminating null byte."

This property is also used in the example in the readlink(2) manpage.

Is this a procfs issue or is the manpage wrong?

Thanks,
//richard
