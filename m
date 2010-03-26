Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781Ab0CZVQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:16:17 -0400
Received: from mail-iw0-f196.google.com ([209.85.223.196]:37020 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab0CZVQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:16:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=YCPKAw2KhDCiwAvvG7TVG2vceGSnmyujwPKoDeE1zZRlq2rPvw+kxBWaROWmFe0U/C
         CwY+SrJoRJqe08h3no+HZQ08saWPegDmsP7MdY98jz17I1rUyWUOZwLYIouGU9s+9Opq
         oT64gUNdBK+ZSNqW3EB/Aidm6YhxszMuWTHMs=
MIME-Version: 1.0
In-Reply-To: <ff13bc9a1003261406w7bf4bb77sf57edce14f0dcc73@mail.gmail.com>
References: <b2cc26e41003241537h228028c4n1374f4b042175885@mail.gmail.com> 
	<g76q40hzkdcrt9mt90UYAxe124vaj_firegpg@mail.gmail.com> <b2cc26e41003251229w5d266c18gd17fdcf404136bd7@mail.gmail.com> 
	<ff13bc9a1003251400ted1993ao73c15ee86e3e717a@mail.gmail.com> 
	<a36005b51003260456m441568c1vcc8b90eed0421b9d@mail.gmail.com> 
	<ff13bc9a1003261406w7bf4bb77sf57edce14f0dcc73@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Fri, 26 Mar 2010 14:15:55 -0700
Message-ID: <a36005b51003261415u1cc89f84r843abaa81f1d7396@mail.gmail.com>
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
To: Luca Barbieri <luca.barbieri@gmail.com>
Cc: Olaf van der Spek <olafvdspek@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 14:06, Luca Barbieri <luca.barbieri@gmail.com> wrote:
>>> None of these perfectly fit, but EINVAL seems the closest.
>>
>> No.  ENOENT is the right value.
>
> Not according to POSIX 2008, which does not explicitly specify this case.

That argumentation is bogus.  You wrote yourself, this situation isn't
(and cannot) be described in POSIX.  For such cases the any error
value is consistent with POSIX.


Again: any value is as good as any other.  The existing value works
and changing it breaks existing code.
