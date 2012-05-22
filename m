Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab2EVVJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 17:09:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59559 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab2EVVJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 17:09:51 -0400
Message-ID: <4FBC0078.7010002@zytor.com>
Date: Tue, 22 May 2012 14:09:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Will Drewry <wad@chromium.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Indan Zupancic <indan@nul.nu>,
        Roland McGrath <mcgrathr@google.com>,
        Eric Paris <netdev@parisplace.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        keescook@chromium.org
Subject: Re: seccomp and ptrace. what is the correct order?
References: <CACLa4puRJLUd6hAHO6zFYiqa5dFVum8eLmNMk_ef+=r8OGhjRg@mail.gmail.com> <CAB=4xho2b5fZV_jC15XW3mhOD9Z0QUMnV_UHy-P5EmQWfX59dA@mail.gmail.com> <5d6179f59222155b72d9aa9f171e883c.squirrel@webmail.greenhost.nl> <CABqD9hbzatHerMA1Nq57Qn8SKSZzZf=5t6aLumG9ZpAafgX=UQ@mail.gmail.com> <20120522173942.GJ11775@ZenIV.linux.org.uk> <CABqD9hbwnp-Kob0-Uc9L=qgJfS88po=RHNPkhQFcSf4RTrFCmQ@mail.gmail.com> <4FBBF84A.4070308@zytor.com> <CABqD9haSh=Tof9n2m8PHBaoqac1kcUZq-f5BcjDBv++5APGTCg@mail.gmail.com>
In-Reply-To: <CABqD9haSh=Tof9n2m8PHBaoqac1kcUZq-f5BcjDBv++5APGTCg@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 01:48 PM, Will Drewry wrote:
> 
> That was my first thought too, so I ran a few simple tests.  gcc isn't
> smart enough to not add ~344 bytes of code to get the number and
> arguments for the x86/kernel/ptrace.c case I included (in the
> naive-est of integrations).  But I don't know that it justifies the
> extra patchwork or enforcing shared code across arches.
> 

I suspect the construction of those inlines can be improved.

	-hpa

