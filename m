Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab1DSGCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:02:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60452 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1DSGCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:02:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=cUp/EMJocWUENatzlBJn6lSrp5JxbJAKGisUQPMm7BtH6YTAfDOw+iVj6e/nKzRy+L
         6NCrDN5CbbC7gm3pL7rgpUE9BznVPNFnS5kpRaaCZ+uatbFbcjNLa/+jmojy28XNwftY
         1vPcjmHIvWn6UgzET9EnmWsOrntHCATl1g8EQ=
MIME-Version: 1.0
Date: Tue, 19 Apr 2011 15:02:15 +0900
Message-ID: <BANLkTinX7cknxL619o6R=0foeQMpTbRK-Q@mail.gmail.com>
Subject: How to mount filesystem from RAM ?
From: Jongman Heo <jongman.heo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I have a flash device and it will store cramfs or squashfs filesystem
in one of its partition.

I can't directly mount it using normal way, for example, "mount
/dev/mtdblock0 /mnt", due to some other constraint.
(And initrd is not an option for me.)

Instead, I can load the data from the partition into RAM, which means
whole filesystem data is copied into some location of RAM. ( I know
the physical address, for the data to be loaded.) This copy operation
is done by bootloader side, not in Linux.

In this case, how can I mount the filesystem from RAM? Is there any
way to do this?

And I think the memory location of filesystem data should be reserved
not to be used by Linux kernel and user space application, am I right?


Thanks in advance,
Jongman.
