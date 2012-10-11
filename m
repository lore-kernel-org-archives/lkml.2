Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2JLCb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 22:31:28 -0400
Received: from ozlabs.org ([203.10.76.45]:57758 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759583Ab2JLCaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 22:30:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: mtk.manpages@gmail.com, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, linux-man <linux-man@vger.kernel.org>,
        Jon Masters <jonathan@jonmasters.org>
Subject: Re: [Request for review] Revised delete_module(2) manual page
In-Reply-To: <CAMOw1v6Cn4VODJ1yEaRwMusf-zUeNjKOYegRkdsKyaqFkjtHRw@mail.gmail.com>
References: <CAKgNAkgp1er3-3nvge9_aVObuuxBatGRur8DtiTzyWK4w+4hrA@mail.gmail.com> <87txu17lss.fsf@rustcorp.com.au> <CAMOw1v6Cn4VODJ1yEaRwMusf-zUeNjKOYegRkdsKyaqFkjtHRw@mail.gmail.com>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 12 Oct 2012 09:16:01 +1030
Message-ID: <87r4p46312.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:
> What do you think? Mark as deprecated now and remove when kernel
> removes it? Or remove now?

Complain now, and I'll queue the removal in two merge windows.

Thats gives us a chance just in case someone actually uses this; if so I
want to talk to them about what it is they want!

Thanks,
Rusty.
