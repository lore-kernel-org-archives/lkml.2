Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab2CXKVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 06:21:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42128 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab2CXKVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 06:21:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAB4K4y5S-X8rCWZaB5ZJeAZupoKajMsKyVw7eMFnAP1v7V5dVw@mail.gmail.com>
References: <CAB4K4y5S-X8rCWZaB5ZJeAZupoKajMsKyVw7eMFnAP1v7V5dVw@mail.gmail.com>
Date: Sat, 24 Mar 2012 11:20:59 +0100
Message-ID: <CAFLxGvwLKD2ZhOZWVo1_hR1r12DpKXZZ273whHqdggrrmdbHFA@mail.gmail.com>
Subject: Re: [PATCH] vfs: fix uninitialised iattr in do_truncate
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 11:10 AM, Ajeet Yadav <ajeet.yadav.77@gmail.com> wrote:
> [PATCH] vfs: fix uninitialised iattr in do_truncate
>
> struct newattrs is uninitialised.
>
> Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>

Does this fix a real bug?
AFAIK notify_change() makes only use of newattrs's initialized members.

-- 
Thanks,
//richard
