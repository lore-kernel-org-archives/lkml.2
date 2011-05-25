Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1EYHUC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:20:02 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45908 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab1EYHT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:19:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=G1hwTUGlliaC1ccDIlc0CLtpXVq8DnxCEOuoKvBXDmcOYSc6q+9T7BGBmgNThN40B/
         k9rdjkWvAdvWdwvZJXJyR2mnSHjKFRLSzyky9e5fTXqwMUqGxxQEUSUsvdDJ7Z5ZpRgg
         2zDwUwb3QEBJMg/M7fCJ1fIIRUi0MzODM5WVM=
MIME-Version: 1.0
Date: Wed, 25 May 2011 15:19:58 +0800
Message-ID: <BANLkTin0GwQYc+fAgSSFcsVysOPfxrin0A@mail.gmail.com>
Subject: vfs: where is get_sb_single()?
From: Bob Liu <lliubbo@gmail.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, folks

I found that fs/super.c doesn't have get_sb_single() anymore.

But I can't find the git log which delete that function.
Some out of tree file systems depends on that function.

Thanks
-- 
Regards,
--Bob
