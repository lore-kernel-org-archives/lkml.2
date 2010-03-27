Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab0C0LuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 07:50:21 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:38124 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab0C0LuU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 07:50:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Yw7Btd5ZgpLN+cAN+Miiyu84lbUMqk3lncBFgO2nj7oWuRElv5r6+3Rnyk4dfzyixD
         qXoPZLeLpo6xGtJohCPUEZeLaIOXtYDL4QkKT7kh079DQ7ndVmnC6qSAtvs4lQzjEwHU
         eq8lnE8UTFSgb/pd1OVa8eLPd+8lcMouBywk4=
MIME-Version: 1.0
In-Reply-To: <a36005b51003261415u1cc89f84r843abaa81f1d7396@mail.gmail.com>
References: <b2cc26e41003241537h228028c4n1374f4b042175885@mail.gmail.com>
	 <g76q40hzkdcrt9mt90UYAxe124vaj_firegpg@mail.gmail.com>
	 <b2cc26e41003251229w5d266c18gd17fdcf404136bd7@mail.gmail.com>
	 <ff13bc9a1003251400ted1993ao73c15ee86e3e717a@mail.gmail.com>
	 <a36005b51003260456m441568c1vcc8b90eed0421b9d@mail.gmail.com>
	 <ff13bc9a1003261406w7bf4bb77sf57edce14f0dcc73@mail.gmail.com>
	 <a36005b51003261415u1cc89f84r843abaa81f1d7396@mail.gmail.com>
Date: Sat, 27 Mar 2010 12:50:18 +0100
Message-ID: <b2cc26e41003270450w1a90f9b2j5cbbae9726122b4e@mail.gmail.com>
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
From: Olaf van der Spek <olafvdspek@gmail.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Luca Barbieri <luca.barbieri@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 10:15 PM, Ulrich Drepper <drepper@gmail.com> wrote:
>> Not according to POSIX 2008, which does not explicitly specify this case.
>
> That argumentation is bogus.  You wrote yourself, this situation isn't
> (and cannot) be described in POSIX.  For such cases the any error
> value is consistent with POSIX.
>
>
> Again: any value is as good as any other.  The existing value works
> and changing it breaks existing code.

It didn't 'work' for me.
What code would break?

Olaf
