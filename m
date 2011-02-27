Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab1B0LLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 06:11:48 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:37764 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1B0LLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 06:11:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=xmLBqlfEUDgMLU6gorFamQhC9HmzALmig4rQ5StFKLE+SeLMrskwUn1Ji1KwEqijbz
         f1jFMk7F/+1wm1G57nK5Ri2T0l+Xvn8LZpQG2j6nd1v5A8ZowLrG0QkVQO8AE1Lu5Hgl
         C09OTHWAdnp4ULKV/0NbSj4APQi30u1e+B0pQ=
MIME-Version: 1.0
In-Reply-To: <1298742844-8256-4-git-send-email-brgerst@gmail.com>
References: <1298742844-8256-1-git-send-email-brgerst@gmail.com>
	<1298742844-8256-4-git-send-email-brgerst@gmail.com>
Date: Sun, 27 Feb 2011 13:11:47 +0200
X-Google-Sender-Auth: ZnBlSBOHXzCo3fXYe1oxhD4gVDw
Message-ID: <AANLkTi=F7tFoBkauFK-R_t7vCjhHmL+cgq+UmpNhCNgZ@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86, boot: merge memcpy()
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 7:54 PM, Brian Gerst <brgerst@gmail.com> wrote:
> Merge the 32-bit and 64-bit memcpy functions.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
