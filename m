Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2GRWiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 18:38:15 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47093 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2GRWiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 18:38:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120718213355.GV31729@ZenIV.linux.org.uk>
References: <5006491D.8070004@t-online.de> <CA+55aFzv5mntf6y9e_r5=v+beG19xBv67EpA=dP0-Zw1CQrGGg@mail.gmail.com>
 <20120718212044.GU31729@ZenIV.linux.org.uk> <CA+55aFyHpgbJ9Pn5xn_ALkvzjQBOWog2qLbwwtrKbPHSGpa6pA@mail.gmail.com>
 <20120718213355.GV31729@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Jul 2012 15:37:52 -0700
X-Google-Sender-Auth: gLmIIFM7EMYJEnXpvMKQjVWwoS4
Message-ID: <CA+55aFx_soQ2sKAcY0yhSFOchkjH55Kvu=jTUW0PJLNxRk9rGQ@mail.gmail.com>
Subject: Re: [Bug 3.4.5] reiserfs: mutex_destroy called with locked mutex
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 2:33 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>  The only questions
> are "is this the WARN_ON() Knut had stepped on" (and I agree with your
> scenario now) and "is it critical enough to shove it into the tree
> less than a week before -final".  Up to you...


I agree that it isn't critical. Even the lockdep thing is just a
warning, and is apparently quite hard to trigger.

Will you hold on to the patch in your VFS tree, and we can just merge
it for 3.6?

                    Linus
