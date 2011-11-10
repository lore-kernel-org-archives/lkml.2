Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab1KJIfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:35:22 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51041 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab1KJIfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:35:20 -0500
MIME-Version: 1.0
Date: Thu, 10 Nov 2011 16:35:19 +0800
Message-ID: <CAFZ0FUUQgQ1FwFMEsDGYNDhW7vt1eB35-if0CUpBAvs-j-G1zA@mail.gmail.com>
Subject: question about epoll
From: Robin Dong <hao.bigrat@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: davidel@xmailserver.org, Dave Jones <davej@redhat.com>,
        coly <colyli@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am a linux user and I found some question when using epoll with EPOLLET.

My program's step:
1. create a socket (sfd) and connect to server2. create epoll (efd)3.
add socket descriptor (sfd) to epoll (efd) with flag EPOLLET4. get a
EPOLLOUT event through epoll_wait
after that, the program will nerver get a EPOLLOUT event because it
use EPOLLET mode (the same event will not be got twice)
BUT£¬when a message comes from server£¬the client socket will get a
event and this event contains EPOLLOUT and EPOLLIN, looks epoll_wait
return too much events than it should
My question is: Is this a designed mechanism or  a bug for epoll ?
Any reply will be appreciate.

-- 
--
Best Regard
Robin Dong
