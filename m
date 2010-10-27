Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0J0SUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 14:20:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61994 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab0J0SUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 14:20:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: nfsd changes for 2.6.37
Date: Wed, 27 Oct 2010 20:20:32 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36+; KDE/4.5.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Bryan Schumaker <bjschuma@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101026164549.GD19445@fieldses.org> <AANLkTinTXoGiFap-vfu0P_SXb5xS+gMsHOwQtN3Hra3r@mail.gmail.com> <20101027174016.GA18974@fieldses.org>
In-Reply-To: <20101027174016.GA18974@fieldses.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010272020.33049.arnd@arndb.de>
X-Provags-ID: V02:K0:M7J/9cZ9DKXE3XLpjBX2PetVD7aRuLnCZZMuPpxpvzw
 6C217QpWCOshxfcwGzblBvBJ43r2wR6LxXCx/o1zc8Ja8srdxm
 geLWq0PPXuZlKzYSeGnOyLBJ4r8gZ357W8Zm8U2aoBtCNp2p9N
 47FMyeWy4U9JaDFxhT4tB4C6LnS7GGTb2ee7WypNr/1xg2kPWN
 LMsHTkugaTMC+Ujsaj+Ng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 October 2010 19:40:16 J. Bruce Fields wrote:
> Doesn't matter to me.  What I've currently got (Arnd's patches with some
> minor fixes from me, and your patch, all in a poorly changelogged
> jumble) is in
> 
>         git://linux-nfs.org/~bfields/linux-topics.git TMP-BKL-TESTING
> 
> You wouldn't want to merge that as is, but it does seem to work.

Ok, then let's use your tree with proper changelogs. That should be the
easiest way to make sure that the code you test is the one that gets in.

	Arnd
