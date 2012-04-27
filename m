Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761404Ab2D0Uob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 16:44:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40263 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760645Ab2D0Uo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 16:44:29 -0400
Message-ID: <4F9B050C.3000309@zytor.com>
Date: Fri, 27 Apr 2012 13:43:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, mjt@tls.msk.ru,
        linux-kernel@vger.kernel.org, autofs@vger.kernel.org, raven@themaw.net,
        thomas@m3y3r.de, stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix design
 error.
References: <20120427.151433.1007849975903946491.davem@davemloft.net> <20120427.151651.2274764174217164454.davem@davemloft.net> <CA+55aFzPbAprx-iT0TYh24uS7+JnL92mbTg_js6Cd_O0q+Dvmw@mail.gmail.com> <20120427.152404.2292425516870981391.davem@davemloft.net> <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com>
In-Reply-To: <CA+55aFzGO+PHmjjVgxnYawbB-wFAqHtkh19vTv1AwQNpc9MsWg@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 12:56 PM, Linus Torvalds wrote:
> 
> What it does is add a new "packetized" flag to pipes, which does two
> simple things:
>  - do not merge write data in pipe buffers when writing
>  - when reading, consider a pipe buffer to be "spent" when any of the
> data has been read
> 

Why not just use the already existing SOCK_SEQPACKET sockets?

	-hpa

