Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab0JCExo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 00:53:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34139 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab0JCExm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 00:53:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=s3Q5Zkiwgi+N8YsqyKtpq66Ldly442P6hUKu2iGgWaS6XJTI770BLWBFrAxnONxcqj
         GMfYCP1b5zz4s/mIrv9t+x9wvWCz2mlRarMNQXeJu04Pkir4rjELZhzC78CC68vs/Wt9
         V3RCycJ6k8U7pbJjGb6/Yzl03B6wCokOWcqQs=
Subject: Re: [PATCH 1/2] net: Fix the condition passed to sk_wait_event()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: tomer_iisc@yahoo.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101002.170654.193719563.davem@davemloft.net>
References: <20101002.132659.71124680.davem@davemloft.net>
	 <970819.25375.qm@web53706.mail.re2.yahoo.com>
	 <20101002.170654.193719563.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Oct 2010 06:53:33 +0200
Message-ID: <1286081613.2582.3235.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 02 octobre 2010 à 17:06 -0700, David Miller a écrit :
> From: Nagendra Tomar <tomer_iisc@yahoo.com>
> Date: Sat, 2 Oct 2010 16:54:23 -0700 (PDT)
> 
> >      I had done the exercise of sending the patch to myself and
> >      applying it (copy-pasting just the patch). One thing that I see
> >      is the long line in the description. If you are referring to
> >      that, I've fixed it and submitted it again. If not this, I'm at
> >      loss.
> 
> This new submission looks good, thank you.

Yes, but the email address in the "Signed-odd-by: ...." is mangled :(


