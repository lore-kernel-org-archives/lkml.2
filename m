Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2DSSL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 14:11:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45677 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2DSSL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:11:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120419173802.GI3221@aftab.osrc.amd.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
 <20120419092255.GA29542@aftab> <20120419092630.GD29542@aftab>
 <4F904541.2030200@zytor.com> <CA+55aFwMsm7zVqPjKptm38zJAbJpF=9e51ew7BP6S5YnoJa3ig@mail.gmail.com>
 <20120419173802.GI3221@aftab.osrc.amd.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 19 Apr 2012 11:11:00 -0700
X-Google-Sender-Auth: oZrA6mp16dJQXvs6MHcGpxm0HLY
Message-ID: <CA+55aFywgsZsxRpYeY2TCHUuK6uRvp8fp8GZEVk50qNc=WS=dw@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86, extable: Handle early exceptions
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 10:38 AM, Borislav Petkov <bp@amd64.org> wrote:
>
> OTOH, if we can share early and normal exception handling lookup code, then a
> perfect hash would make sense as those exceptions would pile up.

Oh, any of this only makes sense if we can share it with the runtime
exception lookup.

They are *seldom* hugely performance-critical, but there are some
unusual loads where you do get a fair number of exceptions.

               Linus
