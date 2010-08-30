Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0H3MCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:02:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63278 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab0H3MCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:02:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [RFC v2 PATCH 0/3] initramfs: cleanups
Date: Mon, 30 Aug 2010 14:02:23 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Phillip Lougher <phillip@lougher.demon.co.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
References: <1283102928-3051-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1283102928-3051-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008301402.23498.arnd@arndb.de>
X-Provags-ID: V02:K0:cw3MLSBXgGk4XKc89D3ZD5ujWkdVygApznzJc9cWBJ/
 ycczk59fuJsHnGEOYH/ECX7lhO+F3B0WU5SjzmWpPHnHGnxiWc
 fki66gbhXpOqttnK/jftbmRUE3lAILYM2Avarlt1gwyyBBX1gm
 /RfiXJpopFn6Ge9Mmh155t8G+sn9sLDwWM5/1QjHB6Mos8cjob
 cXGdV1GFQ5EPWzMH6JgXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 August 2010, Namhyung Kim wrote:
> First two of this patchset wrap all of syscall invocations with kern_sys_*()
> helper functions which does nasty address space conversions for you. This
> idea was suggested by Arnd Bergmann. Last one tries to implement above idea
> - calling internel functions directly - in favour of kernel config option
> even though I'm not sure this is right thing. :-(

I think we can safely say that we do not want the config option, we should
do one option or the other. Since Al already opposed implementing the calls
using low-level VFS operations, that's probably not going to happen.

	Arnd
