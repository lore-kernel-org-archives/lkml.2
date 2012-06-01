Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964949Ab2FATgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 15:36:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44644 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933395Ab2FATgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 15:36:12 -0400
MIME-Version: 1.0
In-Reply-To: <4FB5D1C8.7020305@gmail.com>
References: <4FAFBE24.7000307@gmail.com>
	<20120517154707.c3dc2795.akpm@linux-foundation.org>
	<4FB5D1C8.7020305@gmail.com>
Date: Fri, 1 Jun 2012 12:36:11 -0700
X-Google-Sender-Auth: NtHM8F5NVwtzHnL8PjhgAIb9Spg
Message-ID: <CAE9FiQVqPCRQbg8PShxbUeT5Z0gm88vm76QNT=btGCNRwGP2oA@mail.gmail.com>
Subject: Re: [PATCH] Add Apple NLS
From: Yinghai Lu <yinghai@kernel.org>
To: =?ISO-8859-7?Q?Vladimir_=27=F6=2Dcoder=2Fphcoder=27_Serbinenko?= 
	<phcoder@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 9:36 PM, Vladimir 'ö-coder/phcoder' Serbinenko
<phcoder@gmail.com> wrote:
>> Also, I note that the unicode files have
>>
>>       MODULE_LICENSE("Dual BSD/GPL");
>>
>> Where did this come from?  Is this a thing you decided upon or is it
>> unicode.org's license requirement?
>>

looks like Makefile change is not right... it has hard code =m for new modules.

those line should be removed.

Thanks

Yinghai


diff --git a/fs/nls/Makefile b/fs/nls/Makefile
index f499dd7..b6b0550 100644
--- a/fs/nls/Makefile
+++ b/fs/nls/Makefile
@@ -2,6 +2,18 @@
 # Makefile for native language support
 #

+CONFIG_NLS_MACCELTIC=m
+CONFIG_NLS_MACCENTEURO=m
+CONFIG_NLS_MACCROATIAN=m
+CONFIG_NLS_MACCYRILLIC=m
+CONFIG_NLS_MACGAELIC=m
+CONFIG_NLS_MACGREEK=m
+CONFIG_NLS_MACICELAND=m
+CONFIG_NLS_MACINUIT=m
+CONFIG_NLS_MACROMANIAN=m
+CONFIG_NLS_MACROMAN=m
+CONFIG_NLS_MACTURKISH=m
+
 obj-$(CONFIG_NLS)		+= nls_base.o

 obj-$(CONFIG_NLS_CODEPAGE_437)	+= nls_cp437.o
