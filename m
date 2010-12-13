Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab0LMOZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 09:25:49 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:61807 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab0LMOZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 09:25:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ob/LTydVM+fzAy+KdFwA3bBXOG2HniUM6jhMKNM26Izf6UwC2dWRHhwRmu5cGI2dC+
         cpK9oOk4n4Csl0rM/Bjq5XPU/smr83IldHdd3JB8iinRJnIWt6Iwgb8g+sF4OPafnkRB
         qZuRdHjvrX4/Bil8G+q71WwA7WlY4L3seeKmo=
MIME-Version: 1.0
In-Reply-To: <1292249119-21600-1-git-send-email-aarapov@redhat.com>
References: <1292249119-21600-1-git-send-email-aarapov@redhat.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Mon, 13 Dec 2010 22:25:26 +0800
Message-ID: <AANLkTinG7tZX5E3HG9yyj8JQrH5dkwei0GLxhCqWHWTQ@mail.gmail.com>
Subject: Re: [PATCH] lib: fix vscnprintf() if @size is == 0
To: Anton Arapov <aarapov@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        "Changli Gao <xiaosuo@gmail.com>, Andrew Morton
	<akpm@linux-foundation.org>, Linus Torvalds" 
	<torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 10:05 PM, Anton Arapov <aarapov@redhat.com> wrote:
> vscnprintf() should return 0 if @size is == 0. Update the comment for it,
> as @size is unsigned.
>
> This change based on the code of commit b903c0b8899b46829a9b80ba55b61079b35940ec
> moves the real fix into vscnprinf() from scnprintf() and makes scnprintf() call
> vscnprintf(), thus avoid code duplication.
>
> Signed-off-by: Anton Arapov <aarapov@redhat.com>

Acked-by: Changli Gao <xiaosuo@gmail.com>

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
