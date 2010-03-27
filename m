Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab0C0MFk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 08:05:40 -0400
Received: from mail-iw0-f196.google.com ([209.85.223.196]:39352 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab0C0MFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 08:05:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=s7m6qsXv159cQ9HgQ8gejYY0uADHLIDmsXeXbgSPjR4XHHAP24NWDdUMCyN3f/lqpW
         ioRGRcgeiO0LdJvkfdAQPsIvCs8vVvzcoKi77+owDorkyVZv0OMcY5BMeQhN8mm7RL/V
         FKQv392dUbE5e5g/b0wCSxOIDKXnEoerV24mQ=
MIME-Version: 1.0
In-Reply-To: <b2cc26e41003270450w1a90f9b2j5cbbae9726122b4e@mail.gmail.com>
References: <b2cc26e41003241537h228028c4n1374f4b042175885@mail.gmail.com> 
	<g76q40hzkdcrt9mt90UYAxe124vaj_firegpg@mail.gmail.com> <b2cc26e41003251229w5d266c18gd17fdcf404136bd7@mail.gmail.com> 
	<ff13bc9a1003251400ted1993ao73c15ee86e3e717a@mail.gmail.com> 
	<a36005b51003260456m441568c1vcc8b90eed0421b9d@mail.gmail.com> 
	<ff13bc9a1003261406w7bf4bb77sf57edce14f0dcc73@mail.gmail.com> 
	<a36005b51003261415u1cc89f84r843abaa81f1d7396@mail.gmail.com> 
	<b2cc26e41003270450w1a90f9b2j5cbbae9726122b4e@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Sat, 27 Mar 2010 05:05:18 -0700
Message-ID: <a36005b51003270505s42b5e69co14d2acbb27dc204a@mail.gmail.com>
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
To: Olaf van der Spek <olafvdspek@gmail.com>
Cc: Luca Barbieri <luca.barbieri@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 27, 2010 at 04:50, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> It didn't 'work' for me.

You still don't get it?  No shell provides you with a correct error
message.  There is quite some work involved (reading program header,
finding the interpreter entry, checking the file) to give a meaningful
error message.  Changing the error code alone achieves nothing.


> What code would break?

At the very least the shells in Red Hat releases for many years.
