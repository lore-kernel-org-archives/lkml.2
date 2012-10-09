Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab2JIRV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 13:21:27 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43528 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab2JIRVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 13:21:25 -0400
MIME-Version: 1.0
In-Reply-To: <21146.1349774137@warthog.procyon.org.uk>
References: <21146.1349774137@warthog.procyon.org.uk>
Date: Tue, 9 Oct 2012 19:21:23 +0200
Message-ID: <CAHTX3dKm=f5F_S_tCJK803VYO_sA9EiDoTxZtAQNn+4eOMVGGA@mail.gmail.com>
Subject: Re: [GIT PULL] Disintegrate UAPI for microblaze [ver #2]
From: Michal Simek <monstr@monstr.eu>
To: David Howells <dhowells@redhat.com>
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/9 David Howells <dhowells@redhat.com>:
> Can you merge the following branch into the microblaze tree please.
>
> This is to complete part of the UAPI disintegration for which the preparatory
> patches were pulled recently.
>
> Now that the fixups and the asm-generic chunk have been merged, I've
> regenerated the patches to get rid of those dependencies and to take account of
> any changes made so far in the merge window.  If you have already pulled the
> older version of the branch aimed at you, then please feel free to ignore this
> request.
>
> The following changes since commit 9e2d8656f5e8aa214e66b462680cf86b210b74a8:
>
>   Merge branch 'akpm' (Andrew's patch-bomb) (2012-10-09 16:23:15 +0900)
>
> are available in the git repository at:

Add to microblaze next branch.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
