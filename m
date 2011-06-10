Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab1FJORr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 10:17:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36304 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab1FJORq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 10:17:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=ZEaac8q2gj+y5Jdjo5f5NXUrWUlygbc8jTYlKueG/PG2JVup4U0BXS6YtWfC91issD
         8M3GME4SBLPhdh1Ycl9v3pw1ZqkNAt+zzP0w2kIf3SxogH8McpgNDEh2Eg+Jx+WyfAux
         pxmeyTM2k9bP1G8Zx4PChvzJzMzyAYtFqPblw=
MIME-Version: 1.0
In-Reply-To: <1307711353-5949-1-git-send-email-minipli@googlemail.com>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com>
 <1307642718-22257-1-git-send-email-minipli@googlemail.com>
 <20110609155630.0f734351.akpm@linux-foundation.org> <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
 <1307711353-5949-1-git-send-email-minipli@googlemail.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 10 Jun 2011 10:17:24 -0400
X-Google-Sender-Auth: pZ_NVZVTDm-xzhcU05Mx_nZFCwo
Message-ID: <BANLkTikrZcE_D2LP4W61T9skvmefLMHhgQ@mail.gmail.com>
Subject: Re: [PATCH] blackfin, exec: remove redundant set_fs(USER_DS)
To: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 09:09, Mathias Krause wrote:
> The address limit is already set in flush_old_exec() so this
> set_fs(USER_DS) is redundant.

thanks, ive merged this into my Blackfin tree
-mike
