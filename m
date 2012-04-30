Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab2D3UPC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:15:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60400 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545Ab2D3UPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:15:00 -0400
Message-ID: <4F9EF297.50505@zytor.com>
Date: Mon, 30 Apr 2012 13:14:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        autofs@vger.kernel.org
Subject: Re: autofs: make the autofsv5 packet file descriptor use a packetized
 pipe
References: <20120429205429.63CCD7C0064@ra.kernel.org> <4F9DD994.70202@zytor.com> <CA+55aFy72rPMq3M2_PU0ue45Fb38_Effrfhu2uOpdVXt9H1XOg@mail.gmail.com> <4F9DDD3E.6010801@zytor.com> <4F9EEFF5.4000703@zytor.com> <CA+55aFxXMXmdeHAu3xOBSJEsJ97P_-6qn595FM6s7WXeK0DkjQ@mail.gmail.com>
In-Reply-To: <CA+55aFxXMXmdeHAu3xOBSJEsJ97P_-6qn595FM6s7WXeK0DkjQ@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The thing I *really* hate about the current autofs situation is how it
> really does everything you can possibly do wrong. Not at all the
> "let's just read as much as we can, and look at the return value to
> determine number of bytes/packets", but literally "I know a-priori how
> big the packet is, and I will read exactly that many bytes". That
> coupled with the psueod-fixed-size packets just made it a very very
> fragile thing.
> 

Yes, and that was my fault, originally... back when there was one packet
size and long before compat was a concern.

	-hpa

