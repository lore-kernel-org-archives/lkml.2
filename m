Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1C2JsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 05:48:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60628 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1C2JsC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 05:48:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=snAwDEzOswwMKzz3d85D/WLSJ0j1DeuxEwTePoxLTf0+IXgz/GFMQfBsOOmb+R4qCa
         be9arUZ+F+L+2yxkpjTN1EPgIZY75V0U2YY7Sl1rbDsp45xDT1vb+A/2/iyiczk2JCmA
         Edn+HBT5wJXsR+fd8RDH3Aqy4v+ChLY89zmdE=
MIME-Version: 1.0
In-Reply-To: <AANLkTikQ7j6AOmY3zLjrttVUi0Y+KUTr0ASkhonuaY=g@mail.gmail.com>
References: <AANLkTimWq6RxWycZMugJDmQW3zXPfjHNQXqBbNyGPkvZ@mail.gmail.com>
	<AANLkTikQ7j6AOmY3zLjrttVUi0Y+KUTr0ASkhonuaY=g@mail.gmail.com>
Date: Tue, 29 Mar 2011 17:48:01 +0800
Message-ID: <AANLkTind-ZdwcvGdhXdMJW+6Q5XiMpj7AskoF2WqGi2n@mail.gmail.com>
Subject: Re: Why is there no debug symbols in my vmlinux?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Mr Shore <shore.cloud@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 2:56 PM, Mr Shore <shore.cloud@gmail.com> wrote:
> Hi all!
>
> I've configure all `CONFIG_DEBUG_` related options to `y`,but when I
> try to debug the kernel,it says no debug symbols found:
>
>    gdb /usr/src/linux-2.6.32.9/vmlinux /proc/kcore
>
>    Reading symbols from /usr/src/linux-2.6.32.9/vmlinux...(no
> debugging symbols found)...done.
>
> And I've checked with `make V=1` that there is the -g flag.
>

Hmm, especially CONFIG_DEBUG_INFO and CONFIG_DEBUG_KERNEL.

>
> Why, is this a known issue?
>

No, I will try to see if I can reproduce it here.
