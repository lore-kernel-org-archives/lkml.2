Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab1KRWol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:44:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50703 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab1KRWoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:44:39 -0500
MIME-Version: 1.0
In-Reply-To: <20111118214527.CE6AC2C0E7@topped-with-meat.com>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
	<alpine.LRH.2.00.1111181514220.30965@tundra.namei.org>
	<CAGXu5jJ4h+uCF50DqbLe1m6CRr_Mw3pWq4mEm8nRtDPKV9C2Rg@mail.gmail.com>
	<20111118214527.CE6AC2C0E7@topped-with-meat.com>
Date: Fri, 18 Nov 2011 14:44:38 -0800
X-Google-Sender-Auth: BFlVPNLAjMZl2e9QhxBwTfGhaok
Message-ID: <CAGXu5jJuzjo0bLGcxDgyp6Uj=uJj02BL5Jr+e1WeqUwc18Oe-A@mail.gmail.com>
Subject: Re: [PATCH v6 0/3] security: Yama LSM
From: Kees Cook <keescook@chromium.org>
To: Roland McGrath <roland@hack.frob.com>
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 1:45 PM, Roland McGrath <roland@hack.frob.com> wrote:
>> Do you have any objection to my LSM performing ptrace restrictions?
>> It's entirely self-contained, and all the major upstream crash
>> handlers are already using the prctl() interface it uses to declare
>> ptrace attach relationships.
>
> I don't have the context of what your LSM does.  But other LSMs apply their
> own rules in security_ptrace().  That's what the hook is for.  I'm not sure
> why we would object from the perspective of core ptrace functionality.
> LSMs are LSMs.  Their behavior is between you and your users, as far as I
> am concerned.  As experts on ptrace and aficionados of its users, we may
> have thoughts on what constraints on ptrace users would find annoying.
> But that doesn't mean we'd object per se to whatever bizarre constraints
> users want to ask an LSM to put on them.

Yup, that's precisely what Yama does as well. Sounds like you're not
naking an LSM that uses security_ptrace(), then.

Thanks!

-Kees

-- 
Kees Cook
ChromeOS Security
