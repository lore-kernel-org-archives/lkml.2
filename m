Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab1D0Il6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:41:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55841 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab1D0Ilz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:41:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=wJ8UNiQemnAggsDec6VtHqv84+uL4snr9hzouLKmmTIdTORMZZP0RI3b2sEUiIY7AE
         0H4rUi79QRScmZ+iVRmJwemRmh4sYrMkiTAqbaN3fIgq0ZZszMu5zdLCG6zeIDRA87BX
         SXEIH6858HpVN9Bu9CnwQ9CYbWGwjotuoneXw=
MIME-Version: 1.0
In-Reply-To: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 27 Apr 2011 04:35:19 -0400
Message-ID: <BANLkTik9HQaUjv7+8OetJAf_mCTLhnKcUg@mail.gmail.com>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 14:49, Thiago Farina wrote:
> This macro is arguably more readable than its variants:
> - !strcmp(a, b)
> - strcmp(a, b) == 0

Acked-by: Mike Frysinger <vapier@gentoo.org>
(i dont mind converting any of the Blackfin code to use this)
-mike
