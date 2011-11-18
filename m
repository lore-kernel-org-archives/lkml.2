Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab1KRVjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:39:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46769 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab1KRVjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:39:39 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1111181514220.30965@tundra.namei.org>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
	<alpine.LRH.2.00.1111181514220.30965@tundra.namei.org>
Date: Fri, 18 Nov 2011 13:39:38 -0800
X-Google-Sender-Auth: x3SpdAMch9gTVv3l_uNfCCaE9JQ
Message-ID: <CAGXu5jJ4h+uCF50DqbLe1m6CRr_Mw3pWq4mEm8nRtDPKV9C2Rg@mail.gmail.com>
Subject: Re: [PATCH v6 0/3] security: Yama LSM
From: Kees Cook <keescook@chromium.org>
To: oleg@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>, roland@hack.frob.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 17, 2011 at 8:17 PM, James Morris <jmorris@namei.org> wrote:
> On Wed, 26 Oct 2011, Kees Cook wrote:
>
>> As discussed at the Linux Security Summit, I'm resubmitting this
>> code. As an LSM, it has coherent policy around expanding specific DAC
>> behaviors. There is no need for it to be a full-blown MAC, since it is
>> not intended to be one, but rather to be a simplified expansion to DAC,
>> with system-wide knobs. See the specific patches for details...
>
> In principle, Yama can be merged, however there are features with
> unresolved upstream naks:
>
> - Handling symlinks in sticky directories
> - The ptrace tracker
>
> These still need to be resolved.

Oleg, Roland,

Do you have any objection to my LSM performing ptrace restrictions?
It's entirely self-contained, and all the major upstream crash
handlers are already using the prctl() interface it uses to declare
ptrace attach relationships.

Thanks,

-Kees

-- 
Kees Cook
ChromeOS Security
