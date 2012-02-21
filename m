Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab2BUDjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 22:39:15 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47884 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab2BUDjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 22:39:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.107.67 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329794974.2226.11.camel@perseus.themaw.net>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>
 <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de> <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>
 <20120219.144947.660678318380307878.davem@davemloft.net> <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com>
 <1329794974.2226.11.camel@perseus.themaw.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Feb 2012 19:38:53 -0800
X-Google-Sender-Auth: RsU3Laoy4S1xlXMIYTD8IbL5iXo
Message-ID: <CA+55aFxDXcgOHRk5aPV5aGEDT3chXgcq_ktHKutk7OcyRjDUUw@mail.gmail.com>
Subject: Re: Linux 3.3-rc4
To: Ian Kent <raven@themaw.net>
Cc: David Miller <davem@davemloft.net>, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 7:29 PM, Ian Kent <raven@themaw.net> wrote:
>
> Not sure this is the way you'd like to go with this but here is a patch
> that bumps the major autofs kernel communications version (as yet not
> even compile tested).

.. and exactly how does this fix existing binaries?

                 Linus
