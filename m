Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0EXT4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 15:56:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36378 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab0EXT4E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 15:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=dSgQ9AEvLVqnTt/fUMXEDJZLBAzfuOEuyVdyROlaGm3mWCElU0x+4AepJ2yBoDH0hS
         MPbIwJf70ii2Iw82iYxHprnFvOT41fkCDjjfcS+Q8B8gcS6rNBLvn/N2bi+Myi8zyehf
         BqnNYIIXeaCFxPGIOm9f+ma8v+2fJOosOBr54=
MIME-Version: 1.0
In-Reply-To: <20100522204342.GV22515@bicker>
References: <20100522204342.GV22515@bicker>
Date: Mon, 24 May 2010 21:56:01 +0200
Message-ID: <AANLkTikM6_-YgLcBtcxN_TA1ISHkRk6fCEJVOS7pRZel@mail.gmail.com>
Subject: Re: [patch] caif: remove unneeded null check in caif_connect()
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Dan Carpenter <error27@gmail.com>,
       Sjur Braendeland <sjur.brandeland@stericsson.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <error27@gmail.com> wrote:
> We already dereferenced uaddr towards the start of the function when we
> checked that "uaddr->sa_family != AF_CAIF".  Both the check here and the
> earlier check were added in bece7b2398d0: "caif: Rewritten socket
> implementation".  Before that patch, we assumed that we recieved a valid
> pointer for uaddr, and based on that, I have removed this check.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
Thanks Looks good,
Acked-by: Sjur Braendeland <sjur.brandeland@stericsson.com>
