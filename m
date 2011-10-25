Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1JYHZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:25:51 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65475 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab1JYHZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:25:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com>
References: <CAFkjPT=KcY=YH=Vy+ikyzEe26pwZ3RQ8T=pf+3oGvgECkX7sPw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 25 Oct 2011 09:25:29 +0200
X-Google-Sender-Auth: GEtqhS4JYyU2Q-9edwRwcLRoz8A
Message-ID: <CA+55aFyRpjKrjOkiwUDKb_madynN71neUzCjNVt-TPzsRbEcOQ@mail.gmail.com>
Subject: Re: [GIT PULL] 9p changes fro merge window
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 6:28 PM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>
> are available in the git repository at:
>  git://github.com/ericvh/linux.git for-next

So for the merge window, I *really* want the development trees I pull
from explicitly verified some way.

Now, the p9 patches seem to be small enough, and not core enough, for
me to care deeply, but I really *really* want to not see unsigned
github things.

Putting a signed tag on there somewhere that actually signs the top
commit *and* mentions the repository and branch it is on (ie github)
kis not wonderfully convenient, but it's at least relatively
straightforward (do I have a gpg key I can trust?).

Or using a host that I can trust is being maintained by you guys (or
some trusted third party like kernel.org).

(Also, I'm only seeing about half the patches mentioned in linux-next. Hmm?)

Please? Not pulled.

                   Linus
