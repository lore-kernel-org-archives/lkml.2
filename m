Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228Ab2D1AR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 20:17:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47995 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab2D1AR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 20:17:56 -0400
MIME-Version: 1.0
In-Reply-To: <4F9B33BF.908@zytor.com>
References: <20120427.151433.1007849975903946491.davem@davemloft.net>
 <20120427.151651.2274764174217164454.davem@davemloft.net> <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com>
 <20120427.152404.2292425516870981391.davem@davemloft.net> <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com>
 <4F9B050C.3000309@zytor.com> <CA+55aFz-1n=REkh9SzA1aEz5J_uGc=B_nKj+cP8J=PR6YSZD1w@mail.gmail.com>
 <4F9B2420.5030806@zytor.com> <CA+55aFyCpiU5_nG-3Nra5q9x0-71amAQVetZTxxP6waR1ueYNQ@mail.gmail.com>
 <4F9B33BF.908@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 17:17:34 -0700
X-Google-Sender-Auth: wl0QnFuH9lepTNpCqpsk4hoKzYs
Message-ID: <CA+55aFxnksj5fL68XzkGPQ+aQc0pif+5jjxD=LjGcxKUt039xw@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Miller <davem@davemloft.net>, mjt@tls.msk.ru,
        linux-kernel@vger.kernel.org, autofs@vger.kernel.org, raven@themaw.net,
        thomas@m3y3r.de, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 5:03 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Still, I have to admit... we have a grand total of three users of this
> interface as far as we know (autofs, systemd, and am-utils if they ever
> revved that one to v5.)  Would it really not be better to do the
> zero-eating user space fix?

Considering the sh*t that is in user space now, and how distributions
tend to take years (if ever) to actually update some programs, I don't
see how that would actually work in practice.

                   Linus
