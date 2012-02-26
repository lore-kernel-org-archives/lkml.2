Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab2BZMWM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 07:22:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53489 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab2BZMWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 07:22:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tmezzadra@gmail.com designates 10.236.154.165 as permitted sender) smtp.mail=tmezzadra@gmail.com; dkim=pass header.i=tmezzadra@gmail.com
Message-ID: <4F4A23EC.2040802@gmail.com>
Date: Sun, 26 Feb 2012 09:22:04 -0300
From: "Tomas M." <tmezzadra@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120217 Thunderbird/10.0.2
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux 3.3-rc5 fails to build
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

autofs4 breaks build in 3.3-rc5

---
CC fs/ioprio.o
CC fs/proc_namespace.o
CC [M] fs/autofs4/init.o
CC [M] fs/autofs4/inode.o
fs/autofs4/inode.c: In function ‘autofs4_fill_super’:
fs/autofs4/inode.c:228:2: error: implicit declaration of function 
‘is_compat_task’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

make[2]: *** [fs/autofs4/inode.o] Error 1
make[1]: *** [fs/autofs4] Error 2
make: *** [fs] Error 2


could it be commit a32744d4abae24572eff7269bc17895c41bd0085

autofs: work around unhappy compat problem on x86-64

