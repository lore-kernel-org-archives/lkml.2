Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab0KBBkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 21:40:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61446 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab0KBBkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 21:40:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PB1EULbaeuIg+rhf6gVhqKZPf+b9XV1s7S+cFdy/BhjxioxmYO5qWT6YlQjlOZ6W18
         CZ/MYt0YB2P+Hl56e3BSVZxBnIQrzxJYK5aYbb8U+NkYrJwl9mJxHt6siAOj/6nojWi/
         rJ6xWaxBYW8mGDB1LVgRF5m+u7V4tsm7iOfvU=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=_iawjarxDF8wghrmN4uZ4oFNYeX_K-sqk0ZBO@mail.gmail.com>
References: <AANLkTikfW7QfXX76JM=pDYuQYexPvQz3hrAE=B3YMD5x@mail.gmail.com>
	<20101101092947.GB6023@cr0.nay.redhat.com>
	<AANLkTi=vF50JAFQRMWRDKpbk157amaXpDetna=8==pHn@mail.gmail.com>
	<AANLkTikkh+Pif7DuP3p-fH2=5_otX7N0NSjSB2h13yFC@mail.gmail.com>
	<20101101095922.GE6023@cr0.nay.redhat.com>
	<AANLkTi=_iawjarxDF8wghrmN4uZ4oFNYeX_K-sqk0ZBO@mail.gmail.com>
Date: Mon, 1 Nov 2010 23:40:09 -0200
Message-ID: <AANLkTin79guYW=e0pLZQv+Qw5NNcv6Jm8KcRFvpzsxSZ@mail.gmail.com>
Subject: Re: How many params can be accept by kernel module at most?
From: Thiago Farina <tfransosi@gmail.com>
To: tingwei liu <tingw.liu@gmail.com>
Cc: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 11:42 AM, tingwei liu <tingw.liu@gmail.com> wrote:
> I really use module_param() to provide parameters. How much of the ELF
> section size? How can I find the document of the ELF.

Searching on Google might help?
