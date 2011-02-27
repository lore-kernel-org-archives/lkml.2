Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab1B0LFf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 06:05:35 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42067 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab1B0LFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 06:05:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=rYlQ8XKnJDd403EEl61ceNiui7hknw8Cw2rYO48Sj4w2+GQhQZTq4DQ3Q8dK1Ubyp0
         ushU2DxUr7fBb4XhUT2fYtusgDcAWk/qQ9mZNpFIphaxzEi8Pw4bValKdAVD7NTTn2jX
         BiBGJb+snt5UPw1aTPmS78OfneMjY3/H08nyM=
MIME-Version: 1.0
In-Reply-To: <1298742844-8256-2-git-send-email-brgerst@gmail.com>
References: <1298742844-8256-1-git-send-email-brgerst@gmail.com>
	<1298742844-8256-2-git-send-email-brgerst@gmail.com>
Date: Sun, 27 Feb 2011 13:05:33 +0200
X-Google-Sender-Auth: 8UdkMa_lL7b-tYjLZcnb5ar2Nuo
Message-ID: <AANLkTiksbDLc68VxaJicrNXbS7JH9CT=saYGodenwXbk@mail.gmail.com>
Subject: Re: [PATCH 1/3] x86, boot: Use common ELF header defines
From: Pekka Enberg <penberg@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 7:54 PM, Brian Gerst <brgerst@gmail.com> wrote:
> <linux/elf.h> defines elfhdr and elf_phdr appropriately for 32-bit
> and 64-bit.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
