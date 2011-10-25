Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab1JYJDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:03:52 -0400
Received: from smtp.net4visions.de ([85.214.69.78]:52568 "EHLO
	smtp.net4visions.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012Ab1JYJDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:03:50 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Oct 2011 05:03:50 EDT
X-Spam-Flag: NO
X-Spam-Score: 0.602
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 25 Oct 2011 10:55:55 +0200
From: Markus Kolb <linux-201011@tower-net.de>
To: <linux-kernel@vger.kernel.org>
Subject: Question to directory setgid bit FS implementation details
Message-ID: <af8d5834d1bfb5f19aaf7deba6caa1a0@mail.net4visions.de>
User-Agent: net4VISIONS Webmail/1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

can you please explain in brief how the creation of files
in directories with setgid bit set is implemented in
filesystems.
I'd like to know this for a ext2/3/4 fs, jfs and nfs v3/4
if there are essential differences.

Which source part is responsible for setting the group on
the new file?
Is the effective group of the process changed before creating
the file?
Is there any sync for thread safety during the change of
process group?
Where can I find this sync in source?
Or how is this implemented that the file gets the same group
like the parent directory?

Many thanks
Markus
