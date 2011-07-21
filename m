Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab1GUMW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:22:29 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:56015 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab1GUMW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:22:28 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 3.0: user namespace problem with capabilities
Date: Thu, 21 Jul 2011 14:22:23 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-rc7-00176-gcf6ace1; KDE/4.6.5; x86_64; ; )
Cc: "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Herbert Poetzl <herbert@13thfloor.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107211422.23861.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

linux-vserver guys think that there is a problem with user namespace in 
upcoming 3.0

"this is a mainline/upstream bug, which basically happens
when unsharing the USER namespace. what happens is that
all capabilities are dropped, and as result, the userspace
tool cannot issue Linux-VServer syscall commands anymore
(because of missing CAP_CONTEXT)"

"this can be verified on vanilla linux-3.0 kernels with
http://vserver.13thfloor.at/Stuff/clone_newuser.c
in the following way:

gcc -o clone_newuser clone_newuser.c
./clone_newuser ls /root/

assuming that /root does not have any right for 'other'
this will result in a permission denied (when the USER
namespace is compiled into the kernel)"

Whole post:

http://list.linux-vserver.org/archive?msp:5151:ekldgndhkgmehnehiegi

What's maintainers opinion on this?
-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
