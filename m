Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab0C1Sym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 14:54:42 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:51593 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab0C1Syk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 14:54:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=XyevrwhBZOupkSa7cLCrqzwh5AmoEiPoOI5Fsk8IrEfVNAR6JOJ2g9yVxAhBdKBTfx
         lAZIawYEU/1wKR7hfqrFjYCynMDTAASZMsA4RfdLMA4VTspdN+UxEbjmAWCAP5un081W
         NqhklApIGLKIH9ddk3qYKCr+sPw0GV67A342c=
MIME-Version: 1.0
In-Reply-To: <1269798210-8664-1-git-send-email-justinmattock@gmail.com>
References: <1269798210-8664-1-git-send-email-justinmattock@gmail.com>
Date: Sun, 28 Mar 2010 20:54:38 +0200
X-Google-Sender-Auth: b74a079c79e9771e
Message-ID: <10f740e81003281154i4885f559s3f6ac79f1e697a3e@mail.gmail.com>
Subject: Re: [PATCH] Rename imacfb.txt to efifb.txt and change imacfb to 
	efifb.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 19:43, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> Rename imacfb.txt to efifb.txt since imacfb was moved to
> efifb,and change imacfb to efifb.
> Note:I used git rm for imacfb.txt, but
> git renamed this file to efifb.txt after everything was said and
> done, not sure if this is correct or not.

Git doesn't track renames. It just notices a new file is very similar
(in this case identical)
to a deleted one.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
