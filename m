Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab0JZVi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 17:38:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760400Ab0JZVi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 17:38:26 -0400
MIME-Version: 1.0
In-Reply-To: <20101026212433.GB1842@fieldses.org>
References: <20101026164549.GD19445@fieldses.org> <201010262218.36940.arnd@arndb.de>
 <4CC73BA6.1090407@netapp.com> <201010262255.40481.arnd@arndb.de>
 <AANLkTimPBqafDPxYpZjuym8+-yk4vKYTU15Js-Ux_e6Z@mail.gmail.com> <20101026212433.GB1842@fieldses.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Oct 2010 14:37:26 -0700
Message-ID: <AANLkTinOd9pDVRYDQ5+dqn8LPf4yoOW=j8NxyCfCQAB6@mail.gmail.com>
Subject: Re: nfsd changes for 2.6.37
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Bryan Schumaker <bjschuma@netapp.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 2:24 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
>
> I did a couple connectathon runs just now with no obvious ill effects
> except for some sleep-within-spinlock warnings in the lease code.

Hmm. Those sleep-within-spinlock warnings are very likely serious
bugs. Can you quote the whole warning with stack trace?

                           Linus
