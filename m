Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203Ab2EXULi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:11:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:32828 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225Ab2EXULg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:11:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120524195851.GA15306@core.coreip.homeip.net>
References: <20120524083216.GD10562@core.coreip.homeip.net>
 <CA+55aFxw0HRpizzJZxhhA2oqPpzg4DPUvH2r7YoYfctXS6K=WQ@mail.gmail.com>
 <20120524180154.GA15036@core.coreip.homeip.net> <CA+55aFx0ww=BtYAj9WEbqMT2R30ZZpjd014cYCpC=b+HRtUf_A@mail.gmail.com>
 <20120524195851.GA15306@core.coreip.homeip.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 May 2012 13:11:14 -0700
X-Google-Sender-Auth: kEBlbG8ZweK0D2zAHIhbEj9MjW0
Message-ID: <CA+55aFxX+xidcuVXb1h4oFTemtHo+ANECaoOw=vxtKN231N+cA@mail.gmail.com>
Subject: Re: [git pull] Input updates for 3.5-rc0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 12:58 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
>  Considering your
>
>        dev_set_name(&dev->dev, "input-%s", dev_name(dev->dev.parent));
>
> what happens if I unplug and replug my wacom tablet while event node is
> still opened and therefore all kobjects are still pinned into memory?

I'll let you think about just how stupid that comment was for a moment.

                  Linus
