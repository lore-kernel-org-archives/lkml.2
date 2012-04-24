Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab2DXQQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:16:56 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:46933 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064Ab2DXQQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:16:55 -0400
Message-ID: <4F96D1F6.80701@msgid.tls.msk.ru>
Date: Tue, 24 Apr 2012 20:16:54 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ian Kent <raven@themaw.net>, "stable@kernel.org" <stable@kernel.org>,
        autofs@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Breaking userspace? Re: 3.0.24 broke aufofs on mixed 32/64bit
 environment
References: <4F94222C.6080608@msgid.tls.msk.ru> <1335172741.2226.10.camel@perseus.themaw.net> <4F958352.7050106@msgid.tls.msk.ru> <4F95897B.2040103@msgid.tls.msk.ru> <4F959A5A.8070907@msgid.tls.msk.ru> <CA+55aFyQ4y9jyRXyejKwtf3yXJX52hQkLuwJ5=jfQM+yLkBNMw@mail.gmail.com> <4F96D0E7.9060000@msgid.tls.msk.ru>
In-Reply-To: <4F96D0E7.9060000@msgid.tls.msk.ru>
X-Enigmail-Version: 1.4
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.04.2012 20:12, Michael Tokarev wrote:
> On 24.04.2012 19:08, Linus Torvalds wrote:

>>> Kernel has been shipping with this brokeness for quite
>>> some time, namely, since introduction of autofs4, dated
>>> Mon Mar 27 01:14:55 2006 -0800 (commit 5c0a32fc2cd0).
>>

>> Actually, that's just not true. The *main* users of the interface seem
>> to have never fixed anything. As far as I know, neither the upstream
>> autofs tools nor several of the big distributions ever had patches to
>> make 32-bit autofs work with the old broken 64-bit compat layer.
[]
> I don't know how old this code is, but it definitely is in the
> 5.0.1 upstream tarball, and the file there is dated
> Feb-20, 2007 - at least 3 years after the initial bug in kernel.

I meant to say "about a year after the initial bug in kernel".

And I think it was me who found the original issue, -- i mean,
discovered that it does not work, not found the real bug - but
I don't remember anymore.  This stuff looks very familiar for
some reason however... ;)

Thanks,

/mjt
