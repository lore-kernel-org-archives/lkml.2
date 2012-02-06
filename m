Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab2BFX3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 18:29:51 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46425 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab2BFX3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 18:29:50 -0500
MIME-Version: 1.0
In-Reply-To: <20120205062206.GA1853@ericsson.com>
References: <20120205062206.GA1853@ericsson.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Feb 2012 15:29:30 -0800
X-Google-Sender-Auth: JN1a9qunU7WKUOOeqIiq4kqRiEU
Message-ID: <CA+55aFy7LpNP1ZPwtDNkJP51Utqon7i0QSieX35eL=6i0BRyHA@mail.gmail.com>
Subject: Re: [GIT PULL] hwmon subsystem fixes for 3.3-rc3
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 4, 2012 at 10:22 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
>
> Signed tag: hwmon-fixes-for-3.3-rc3
>
> Just a single patch this time.
>
> Since this is the first time I tried using a signed tag, I provided both a
> branch and a signed tag to pull from. If the tag works, I'll only provide
> the tag next time. If something is wrong with the tag, please let me know.

The thing technically works, but you really want a few more signatures
on it. I can see Tom Grennan, whose key in turn is signed by several
people, but if possible, try to get some exposure for that key.

Anyway, pulled.

                      Linus
