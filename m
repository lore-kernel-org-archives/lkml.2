Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602Ab0EMXBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:01:50 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63377 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab0EMXBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=pc/q/QwBWZ7sDBZy/EkQq4+vtOFh5FkiSxLlGmPevBYW5LKHPc1AmI+eIQ6HJCYMK4
         E1MrDafNn6P6FpQ58GGS19uFoJALRoX5ia3QNW+WcNsqBBazJg7o4sPGGzRwtz9o4Cip
         RI0dofDD83EuM3gxmWm7VXlWU/Di14WbdSJ/Y=
MIME-Version: 1.0
In-Reply-To: <4BEC7A84.3010503@gmail.com>
References: <4BEC7A84.3010503@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 13 May 2010 16:01:29 -0700
X-Google-Sender-Auth: NkKJvVUtnODPhiQq8oJa-2seSNc
Message-ID: <AANLkTim7B5z76zJ33by6SGMgSy1gZF6qiwhEhAQ3NUtG@mail.gmail.com>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 3:17 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> not sure what this is, but while at a convention
> I was trying to access the internet and(below is
> full dmesg) this showed up.
>
> After receiving this, I sat and tried to re-create
> my steps to reproduce but had no luck(was even going
> todo a bisect n the spot if I could re-create).

OK this stuff is hard to reproduce it seems.. you have an Atheros
AR5418 MAC/BB Rev:2 AR5133 RF Rev:81, what kconfig option do you use
to get the poison stuff? I am just surprised we haven't seen it
ourselves yet. Let me make sure all of us get this kconfig option
enabled.

  Luis
