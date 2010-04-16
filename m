Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab0DPSJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 14:09:18 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:63756 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab0DPSJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 14:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=ibEKgEOk8qalE419AYziKO+M3umm9WHxYVktuszcHRqgCXA419KvBaOZCstKx8BbXV
         BsAsLSkql1AcO/HIKkYwSGHotGbF/TJ5NgMFY2g7xysGBn4pz6XOkaB8O+Uv1zwMpQnk
         qEfduzVV4xFH9qSFDj34Y6M0sUgrQdFz8IQws=
Message-ID: <4BC8A7C1.20102@gmail.com>
Date: Fri, 16 Apr 2010 20:09:05 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.3 Thunderbird/3.1b1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: adilger@sun.com, linux-ext4@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jan Kara <jack@suse.cz>
Subject: busy inodes -> ext3 umount crash
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with mmotm 2010-04-05-16-09 and much older (I hadn't camera to take a
picture) I sometimes get a BUG() trace in ext3 umount code:
http://www.fi.muni.cz/~xslaby/sklad/panics/ext3_1.png
http://www.fi.muni.cz/~xslaby/sklad/panics/ext3_2.png

I have no idea how to reproduce it :(, but it usually happens when I do
shutdown/kexec.

Those busy inodes are pretty common in current kernels, I don't know if
that's related -- I doubt it since it is for different bdevs.

Do you have any clue what to test, how to debug that?

@Honza: this is the one we talked about earlier, you wanted to see
details, but I thought it disappeared. (Just in case you are interested.)

Thanks.
