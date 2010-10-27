Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab0J0UU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 16:20:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53505 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab0J0UUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 16:20:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: nfsd changes for 2.6.37
Date: Wed, 27 Oct 2010 22:20:20 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36+; KDE/4.5.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Bryan Schumaker <bjschuma@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101026164549.GD19445@fieldses.org> <201010272148.47376.arnd@arndb.de> <20101027200145.GE18974@fieldses.org>
In-Reply-To: <20101027200145.GE18974@fieldses.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010272220.20567.arnd@arndb.de>
X-Provags-ID: V02:K0:LNB1Ots3XwsUTXrblPmfZmQF22XSv5BO4Z1EJt/fkSq
 eeiFTXilsquj2BXXs3lmnCbTT7p07AtVkIDWbhpeAC37QS1+zc
 SvYK5FH61hG7gYAhCKsDbTZn2SxKMjpSLcRW06vEHLaQ0x8Xzi
 lTouFJSP6u5fAqufB+MMJy+LMJ0JwGwnUxyBomIBEQRTAEpa80
 hvoKRBxi4z0I8QMP+Q/tg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 October 2010 22:01:45 J. Bruce Fields wrote:
> (You're missing Linus's comment fix, though, unless I'm confused.)

Right, I didn't look into the attachment, so I hadn't noticed
the new changelog. I've updated the changelog to Linus' version,
as it's more verbose than mine.

I also checked that the version in your tree is actually the
right one, so I left the code untouched.

	Arnd
