Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab2JPSs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:48:59 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36253 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755161Ab2JPSs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:48:58 -0400
Message-ID: <1350413336.8077.6.camel@dabdike>
Subject: Re: [GIT PULL] Disintegrate UAPI for parisc [ver #2]
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Howells <dhowells@redhat.com>
Cc: jejb@parisc-linux.org, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Oct 2012 11:48:56 -0700
In-Reply-To: <21164.1349774145@warthog.procyon.org.uk>
References: <21164.1349774145@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 10:15 +0100, David Howells wrote:
> Can you merge the following branch into the parisc tree please.
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

I'm getting a fairly massive merge failure over our misc tree:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/parisc-2.0 misc

It looks like a conflict with the motion to using wrappered Kbuild for
our asm-generic clones.

James


