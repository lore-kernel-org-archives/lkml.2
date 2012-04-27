Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab2D0MNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:13:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65099 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab2D0MNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:13:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/2] asm-generic: io: remove {read,write} string functions
Date: Fri, 27 Apr 2012 12:12:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        Mike Frysinger <vapier@gentoo.org>
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com>
In-Reply-To: <1335523376-14695-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204271212.11205.arnd@arndb.de>
X-Provags-ID: V02:K0:zqOZV4xdUwkNMle9mP4Dggudjs4x5SrEm8kH0LP7Ah0
 oKJLietfRMMRtxVSO8A9j+0Nsen0t7V7e0iI31+JucnfwzmwEL
 qen96hAA97uwnMy6BPZ5j5b1SbD1bThVP5iDqaxT2/KEcvY6is
 aGO5r3MOAAZGwDT26V6XkHqSEybmpSG3hwRbxzbrS66XZ6todr
 RL8ieGMxP/6KwJsep00+Ptm0DmpjwGCRUKvlgveSlxrjVCXXow
 j/9StC0VxQHikT2Ts35M9gDoZ2urhAseVMWfVlE06F/xQb/4Ft
 WGraeU+FF53cl57BaRlSKnoZdxjl9egJT3+1xVcTtq2UnRypGp
 GmTy84CeC8EDrXbJR1Vc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 April 2012, Will Deacon wrote:
> The {read,write}s{b,w,l} functions are not defined across all
> architectures and therefore shouldn't be used by portable drivers. We
> should encourage driver writers to use the io{read,write}{8,16,32}_rep
> functions instead.
> 
> This patch removes the {read,write} string functions for the generic IO
> header as they have no place in a new architecture port.

I think we need to put these functions back into the blackfin version,
basically reverting efb2d31c1c, but otherwise the patch looks good
to me.

	Arnd
