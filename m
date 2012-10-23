Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965378Ab2JWU6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:58:47 -0400
Received: from 75-15-5-89.uvs.iplsin.sbcglobal.net ([75.15.5.89]:51557 "EHLO
	peff.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933732Ab2JWU6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:58:44 -0400
Date: Tue, 23 Oct 2012 16:51:19 -0400
From: Jeff King <peff@peff.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Chris Metcalf <cmetcalf@tilera.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>, git@vger.kernel.org,
        Junio C Hamano <gitster@pobox.com>
Subject: Re: [PATCH] tile: support GENERIC_KERNEL_THREAD and
 GENERIC_KERNEL_EXECVE
Message-ID: <20121023205119.GA27729@sigill.intra.peff.net>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
 <201210192041.q9JKf7jD003998@farm-0010.internal.tilera.com>
 <20121019213548.GR2616@ZenIV.linux.org.uk>
 <5082A1F1.3080303@tilera.com>
 <20121020153401.GT2616@ZenIV.linux.org.uk>
 <20121020171643.GU2616@ZenIV.linux.org.uk>
 <5086D432.4070008@tilera.com>
 <20121023184122.GZ2616@ZenIV.linux.org.uk>
 <alpine.LFD.2.02.1210232232070.2756@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1210232232070.2756@ionos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:47:28PM +0200, Thomas Gleixner wrote:

> I agree that this is a common issue. Acked-by/Reviewed-by mails come
> in after the fact that the patch has been committed to an immutable
> (i.e no-rebase mode) branch or if the change in question already hit
> Linus tree.
> 
> Still it would be nice to have a recording of that in the git tree
> itself.
> 
> Something like: "git --attach SHA1 <comment>" would be appreciated!

It is spelled:

  git notes add -m <comment> SHA1

The resulting notes are stored in a separate revision-controlled branch
and can be pushed and pulled like regular refs. Note, though, that the
default refspecs do not yet include refs/notes, so you'd have to add
them manually. The workflows around notes are not very mature yet, so if
you start using them, feedback would be appreciated.

-Peff
