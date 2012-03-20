Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030589Ab2CTJA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 05:00:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39316 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965000Ab2CTJAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 05:00:53 -0400
MIME-Version: 1.0
Date: Tue, 20 Mar 2012 14:30:52 +0530
Message-ID: <CAJrcCc0=aXe-us32KmkiBH9mdDyEcPYuSa6Ejj_LX0=1FNgoDQ@mail.gmail.com>
Subject: __NR_create_module for arm
From: Vivek Singh <vivek.siwan@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello There,

While compiling tomoyo-tools for arm I  found that NR_create_module
is not available in
arch/arm/include/asm/unistd.h

#define __NR_sigprocmask
  (__NR_SYSCALL_BASE+126)
                                                       /* 127 was
sys_create_module */
#define __NR_init_module                (__NR_SYSCALL_BASE+128)


But it is available in

./arch/x68/include/asm/unistd_32.h

#define __NR_sigprocmask        126
#define __NR_create_module      127
#define __NR_init_module        128

is there any reason why it is not available for arm ?

Thanks and regards
