Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1HXNe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:34:59 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:44035 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab1HXNe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:34:57 -0400
MIME-Version: 1.0
Date: Wed, 24 Aug 2011 06:34:57 -0700
Message-ID: <CAMe9rOrejBbutqRMuE1f5iVn3nr8+zOmFyXgGmn=R9zHMC6U8Q@mail.gmail.com>
Subject: Delete x86-64 __IGNORE_getcpu?
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

arch/x86/include/asm/unistd_64.h has

#define __IGNORE_getcpu         /* implemented as a vsyscall */

But there are

#define __NR_getcpu                             309
__SYSCALL(__NR_getcpu, sys_getcpu)

Shouldn't __IGNORE_getcpu be deleted?

-- 
H.J.
