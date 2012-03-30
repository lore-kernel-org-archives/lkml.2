Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363Ab2C3AJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 20:09:53 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59049 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab2C3AJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 20:09:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120328192816.GD22414@n2100.arm.linux.org.uk>
References: <1332918842-13521-1-git-send-email-olof@lixom.net>
 <1332918842-13521-2-git-send-email-olof@lixom.net> <20120328082501.GA22414@n2100.arm.linux.org.uk>
 <CAOesGMjwZOON9kFNvaEq8QhSvjAgsJT_J1Ysb9-AbePd6g+-rQ@mail.gmail.com> <20120328192816.GD22414@n2100.arm.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Mar 2012 17:09:27 -0700
X-Google-Sender-Auth: MbEP-pLO4HmOue0aZgmV4p78oq4
Message-ID: <CA+55aFyJH8yO7=AzuddsQZouHqRDtmeh-vbd8Y5VQLQx-6ZV-Q@mail.gmail.com>
Subject: Re: [GIT PULL 1/5] ARM: cleanups of io includes
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 12:28 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>
> Right, having merged the latest arm-soc tree this evening into the build
> tree and forced a rebuild, the errors induced by Rob's patches are now
> gone, so I'm fine with this going in now.

Ok, I'm getting back to this pull request, and apparently everything
is ok with it.

Holler if not, because it's not back on my queue of trees to merge
(but I haven't actually gotten to it yet - this is just a heads-up
that I will get to it later today).

                        Linus
