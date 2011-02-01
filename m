Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1BARrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:47:11 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:62214 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab1BARrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:47:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19784.18282.668305.184521@quad.stoffel.home>
Date: Tue, 1 Feb 2011 12:48:26 -0500
From: "John Stoffel" <john@stoffel.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.38-rc3 - make deb-pkg bombs out
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been trying to do a 'make deb-pkg' on 2.6.38-rc? and not having
any luck.  I was going to report this error for -rc2, but saw -rc3
this morning so I grabbed it and tried it out.  

I can successfully build the kernel on x86_64 (Ubuntu 10.10 system,
dual core Athlon, 4gb RAM, current directory mounted via NFS), but
when I do:

  fakeroot make O=/var/tmp/build deb-pkg

it dies with the following error:

      INSTALL include/rdma (1 file)
      INSTALL include/scsi/fc (4 files)
      INSTALL include/scsi (3 files)
      INSTALL include/sound (8 files)
      INSTALL include/video (3 files)
      INSTALL include/xen (2 files)
      INSTALL include (0 file)
      INSTALL include/asm (56 files)
    find: `arch/x86/include': No such file or directory
    make[2]: *** [deb-pkg] Error 1
    make[1]: *** [deb-pkg] Error 2
    make: *** [sub-make] Error 2

Anyone got a hint on what the solution is?

John

       
-- 
