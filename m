Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0H0NVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:21:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59079 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab0H0NVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:21:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [RFC PATCH 01/43] ptrace: change signature of sys_ptrace() and friends
Date: Fri, 27 Aug 2010 15:21:35 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com> <1282902149-12991-2-git-send-email-namhyung@gmail.com>
In-Reply-To: <1282902149-12991-2-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008271521.35995.arnd@arndb.de>
X-Provags-ID: V02:K0:GFldEvUZlv1I+UuYLVPVZwDPC26LbHsDqizHs4ORqY/
 1QX7tmDUgpxZlz2JCQ2PBOUsRDYEmB0SshvzJsgloBZv0B98dz
 BOSFkci6MKYMD9xb6X7gmmFORKHezudu4gu2JmM8dOhI4BNUGN
 KQD7cbUVwvcqVcTSe+FrK7A0c4DXjPbUraFHc1QNfpJavWca1n
 Rw8RHZ+hb6NB0gMLKpAjA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 August 2010, Namhyung Kim wrote:
> Since user space API of ptrace syscall defines @addr and @data as void
> pointers, it would be more appropriate to define them as unsigned long
> in kernel. Therefore related functions are changed also.
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Looks good to me. It may be worth mentioning in the changelog that
'unsigned long' is typically used in other places in the kernel
as an opaque data type and that using this helps cleaning up a lot
of warnings from sparse.

Acked-by: Arnd Bergmann <arnd@arndb.de>
