Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab0H2NlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 09:41:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49929 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab0H2NlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 09:41:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [RFC PATCH 03/43] ptrace: change signature of arch_ptrace()
Date: Sun, 29 Aug 2010 15:40:55 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35+; KDE/4.5.0; x86_64; ; )
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com> <201008271628.40023.arnd@arndb.de> <87occof2mw.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
In-Reply-To: <87occof2mw.fsf@NHK-XNOTE.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008291540.55414.arnd@arndb.de>
X-Provags-ID: V02:K0:CQJ/dUstJmru3CU1K5a0MnyaBDcGdXOZgwmoZwaAX17
 rTWNNiWDopDW/MR9XUniwLTNX6cs7gEsNZgZFo4scYxLIpAtbR
 JFxoeux4fJLzMtHlEhEiulUUwjz9Rab4sNmBTVwOPSkelC7gan
 Vckn0iMD0AAu1zJEY5e9CvMhKILOwS0jP+OHyLcrxePE/rfXx4
 fIZgaYxtkfeG9umi4tt8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 August 2010 18:20:55 Namhyung Kim wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> > Would it be possible to rearrange your patches so that you don't break
> > anything in the middle? I think merging all the trivial 'change signature'
> > patches into one would also make reviewing easier. Nobody in their
> > right mind is looking through a full series of 43 patches, especially
> > if they do not make sense on their own, but one patch that changes a
> > function signature tree-wide would be looked at by many people and can
> > be applied standalone.
> >
> 
> OK. Will combine those.
> BTW, one thing I wonder is it will have huge CC list of arch maintainers
> in commit message, so is it usual? or is there other way?

I'd say you don't have to for a trivial patch such at this, as long as
you keep linux-arch@vger.kernel.org on Cc, since that has all the arch
maintainers. It also doesn't hurt to keep them all on Cc, since it would
only be a single mail then.

	Arnd
