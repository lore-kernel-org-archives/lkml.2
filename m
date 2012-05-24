Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab2EXReN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:34:13 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52967 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab2EXReL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:34:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120524083216.GD10562@core.coreip.homeip.net>
References: <20120524083216.GD10562@core.coreip.homeip.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 May 2012 10:33:49 -0700
X-Google-Sender-Auth: fxSn7lAkwNNUpOF7gzpQZF3Eixo
Message-ID: <CA+55aFxw0HRpizzJZxhhA2oqPpzg4DPUvH2r7YoYfctXS6K=WQ@mail.gmail.com>
Subject: Re: [git pull] Input updates for 3.5-rc0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 1:32 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Linus,
>
> to receive updates for the input subsystem. You will get:

I get an annoying conflict, and the reason I call it annoying is not
because it's hard to resolve, it's because doing that shows that you
seem to have preferred using

   dev_dbg(&input->dev.parent, ...)

over the much more natural

   dev_dbg(&input->dev, ...)

which would seem to make more sense.

Why? Are the input layer device names so bad that using them for debug
output is useless? And if so, why *are* they so bad?

I'm going to take your version over Greg's more straightforward one,
because I assume Greg did things a bit more mindlessly and I think you
presumably had a *reason* for your extra (stupid) ".parent" part. But
I'm unhappy with it, because I suspect the reason you did that implies
that the input layer does something bad.

Hmm?

                     Linus
