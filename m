Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab0H3FZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 01:25:18 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64575 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab0H3FZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 01:25:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=bfFW1fmhWAjH1kWs4/kGFUN8x6hC6v8sGAAK0/MESx3bQE7EonSp+zBuxEArsfK1ia
         iMsXHIV6awpr1e6zN95nru9OoxeoLQnf58AFnUql2BlDIgYi1PHXgNuWrB7TH3Z4Mr2i
         /MBMlJPE++HKp5On5LrX9cBpPOsIgVz0W6DnI=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <AANLkTim_seWr0LZJyC+dPBy-N+_NkzTx21vte7qrwunC@mail.gmail.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
 <20090204150507.665b5b7c.akpm@linux-foundation.org> <alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com>
 <20090204152434.c8f65d52.akpm@linux-foundation.org> <alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com>
 <20090204155514.6abbdc8f.akpm@linux-foundation.org> <cfd18e0f0902041559l4c40d9b6k704068337a00df7a@mail.gmail.com>
 <alpine.DEB.1.10.0902041600170.6214@alien.or.mcafeemobile.com> <AANLkTim_seWr0LZJyC+dPBy-N+_NkzTx21vte7qrwunC@mail.gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Mon, 30 Aug 2010 07:24:48 +0200
Message-ID: <AANLkTi=h0roGfS6PBMk=0D_ZqC5h9OxX-QdTe9pK1Sk-@mail.gmail.com>
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 7:21 AM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:

> It took a while, but here's the new text in the eventfd.2 (will be in
> man-pages-2.36). Could you please ACK, Davide?

Oops: s/2.36/3.26/

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
