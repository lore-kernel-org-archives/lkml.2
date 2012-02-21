Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2BUETM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 23:19:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40200 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab2BUETL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 23:19:11 -0500
Message-ID: <4F431B1D.90704@zytor.com>
Date: Mon, 20 Feb 2012 20:18:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org
Subject: Re: Linux 3.3-rc4
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com>  <FE1DCD87-0055-4C3E-B06A-251055E1492F@m3y3r.de>  <CA+55aFzUWDEuj85sOKjwk8ufy+1rbS7hgstw0cCWpjTgu=7B4A@mail.gmail.com>  <20120219.144947.660678318380307878.davem@davemloft.net>  <CA+55aFwqChUmmDfoYX7HRUUZg5s7nBOh834=g+7avj=yc42gGg@mail.gmail.com> <1329794974.2226.11.camel@perseus.themaw.net>
In-Reply-To: <1329794974.2226.11.camel@perseus.themaw.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 07:29 PM, Ian Kent wrote:
> 
> Fix this by adding a new protocol version 6 packet that is packed so that
> it will have the same size on all archectures regardless of alignement.
> 

You probably also want to make sure there aren't any holes in it, ever.
 Alignment holes not only cause these kinds of problems, but also cause
security holes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

