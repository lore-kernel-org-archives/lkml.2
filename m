Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816Ab2D0RK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:10:59 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:39137 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759978Ab2D0RK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:10:57 -0400
Message-ID: <4F9AD31F.8080109@msgid.tls.msk.ru>
Date: Fri, 27 Apr 2012 21:10:55 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        autofs@vger.kernel.org, raven@themaw.net, thomas@m3y3r.de,
        stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix design
 error.
References: <1335447289-9909-1-git-send-email-mjt@msgid.tls.msk.ru> <CA+55aFxEP7-+N7vTPZ-4hD-UirZ=+YMJh2x3EjZvUmjjyOchtg@mail.gmail.com> <4F9A6ABA.6050503@msgid.tls.msk.ru> <20120427.122207.795060203454499065.davem@davemloft.net>
In-Reply-To: <20120427.122207.795060203454499065.davem@davemloft.net>
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.04.2012 20:22, David Miller wrote:
> From: Michael Tokarev <mjt@tls.msk.ru>
> Date: Fri, 27 Apr 2012 13:45:30 +0400
> 
>> Please note: the talk is about 32bit userspace on 64bit kernel,
>> which should be quite rare these days, or something of less
>> priority.
> 
> You're talking about %99 of powerpc and sparc systems.

Nope.  Only about x86 32 on 64 bits, and only with 3.3 kernel.
The original problem does not exist on ppc, at least as far as
I understand.

/mjt

