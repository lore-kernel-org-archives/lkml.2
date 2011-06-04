Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab1FDIi1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 04:38:27 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64839 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1FDIi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 04:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=XxmajfXaMHZ0KIcvD6YM9q7fGSarw0eOTKrprniNlICOMlfxgmBfvSe3tMAjshuHbP
         E01ZY3URXpavsUGYFqFwSyBYd8zjCrY3HWoboj2ucnpOkbPQM3v4m72fUKcpV5LEORDA
         F7VKG2u5cayh6FoXtiGQnuqxY9nm0DrrTxch8=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 4 Jun 2011 10:38:25 +0200
Message-ID: <BANLkTi=sBfRri4=rQX2YCqMNnaQK-SAsUA@mail.gmail.com>
Subject: Re: Revert "slub: Remove node check in slab_free"
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What happened to that revert-patch?
( Not in -tip... not in -slab... not in mainline. )

- Sedat -

[1] https://patchwork.kernel.org/patch/815332/
