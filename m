Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332Ab2FGBao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 21:30:44 -0400
Received: from tundra.namei.org ([65.99.196.166]:37483 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630Ab2FGBal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 21:30:41 -0400
Date: Thu, 7 Jun 2012 11:29:48 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Will Drewry <wad@chromium.org>
cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, Eric Paris <eparis@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>, djm@mindrot.org,
        scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com,
        Jonathan Corbet <corbet@lwn.net>, eric.dumazet@gmail.com,
        markus@chromium.org, coreyb@linux.vnet.ibm.com,
        linux-man@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: Docs for PR_SET_NO_NEW_PRIVS
In-Reply-To: <CABqD9hYXKhX1=064DpbaBTAVd8-g43jKAPvtsbxEUTbgC1MPxg@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1206071127340.12194@tundra.namei.org>
References: <4FCE3C18.4080302@amacapital.net> <CAGXu5jLc6UW85TxA7ccA4e1u78hkTbSrWeBJE+oTXXQECPvtjg@mail.gmail.com> <CABqD9hYXKhX1=064DpbaBTAVd8-g43jKAPvtsbxEUTbgC1MPxg@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2012, Will Drewry wrote:

> Or Documentation/prctl/no-new-privs.txt
> 
> Just a decision between what it does and how you get to it, but I'd
> think either would make sense!

This makes sense as it's where the seccomp documentation is.


- James
-- 
James Morris
<jmorris@namei.org>
