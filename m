Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab1B0LHX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 06:07:23 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57117 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab1B0LHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 06:07:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=FimpewHyXk3Wf5qiAksGa0kiHgQZOITTnkQOsUqnpplDIo6oq0XFthVFmwGiFcPGvs
         QKCj34no98BLxZ8BMtkklIqYcUsmnOaknT+TuGsn1zeToyZ/ptkfIGDDd7r7UGJhhUWz
         rQASuSk6WyHumynC3eWbwN4LqEcIsyZOAQkUM=
MIME-Version: 1.0
In-Reply-To: <1298742844-8256-3-git-send-email-brgerst@gmail.com>
References: <1298742844-8256-1-git-send-email-brgerst@gmail.com>
	<1298742844-8256-3-git-send-email-brgerst@gmail.com>
Date: Sun, 27 Feb 2011 13:07:21 +0200
X-Google-Sender-Auth: 3j5Qtnn_6eFoX9Dyd_e0b3ByUtg
Message-ID: <AANLkTinGi=8LbFdzNRv9B5_TNH=v+FE6NU6WmaRj4qHY@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86, boot: Remove memptr
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 7:54 PM, Brian Gerst <brgerst@gmail.com> wrote:
> Use unsigned long for free memory pointers for both 32-bit and 64-bit.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
