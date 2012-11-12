Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab2KLQub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 11:50:31 -0500
Received: from smtprelay0188.b.hostedemail.com ([64.98.42.188]:33059 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752856Ab2KLQu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 11:50:29 -0500
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 1629
Date: Mon, 12 Nov 2012 16:50:27 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Cc: dave@gnu.org, akpm@linux-foundation.org, torvalds@linux-foundation.org
Message-ID: <545706980.41498.1352739027798.JavaMail.mail@webmail19>
Subject: OOM changes in Linux 3.7 lead to udev warnings and total breakage
 of KDE 3.5.10/TDE
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [92.255.131.9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

If I remember correctly kernel developers promised not to break user APIs in the Linux kernel
however in Linux 3.7 a /proc/<PID>/oom_adj file has been totally removed which makes KDE 3.5.x
(and I suppose TDE) unusable as they depend on this file and simply refuse to start in its absence.

Also, udev in CentOS/RHEL/Scientific and other old Linux'es depend on this file (which is not critical
but not pleasant anyway).

I'm not a hacker/programmer to edit and recompile udev/KDE/TDE sources so I'd be glad if
this file was restored.

If the interface behind this file was totally removed and there's no way you can bring it back,
can I politely ask to export a dummy oom_adj file which allows the same mode of access yet
the kernel does nothing in return.

--
Thank you,

Artem
