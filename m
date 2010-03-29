Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0C2Okk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:40:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40464 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0C2Oki convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:40:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eiQ2pt4OrTJsmhy6F7MWy3ju8VB2P8/jSeN5H9i999ozxZcVYzMDfJZ4pVFaR0MM/S
         tH45BwFdfaZQQfQdH8XEsWpR8uCvxb/8hcpALa9fgfUbsPv5gN1kS0rTXVNNGW6vHIq4
         3P5zi2tcu1r/E7uiL8iIQ041Jktkb0qEZPVpM=
MIME-Version: 1.0
In-Reply-To: <a36005b51003270505s42b5e69co14d2acbb27dc204a@mail.gmail.com>
References: <b2cc26e41003241537h228028c4n1374f4b042175885@mail.gmail.com>
	 <g76q40hzkdcrt9mt90UYAxe124vaj_firegpg@mail.gmail.com>
	 <b2cc26e41003251229w5d266c18gd17fdcf404136bd7@mail.gmail.com>
	 <ff13bc9a1003251400ted1993ao73c15ee86e3e717a@mail.gmail.com>
	 <a36005b51003260456m441568c1vcc8b90eed0421b9d@mail.gmail.com>
	 <ff13bc9a1003261406w7bf4bb77sf57edce14f0dcc73@mail.gmail.com>
	 <a36005b51003261415u1cc89f84r843abaa81f1d7396@mail.gmail.com>
	 <b2cc26e41003270450w1a90f9b2j5cbbae9726122b4e@mail.gmail.com>
	 <a36005b51003270505s42b5e69co14d2acbb27dc204a@mail.gmail.com>
Date: Mon, 29 Mar 2010 16:40:36 +0200
Message-ID: <b2cc26e41003290740i5c548cabgc95d91958cd1075a@mail.gmail.com>
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
From: Olaf van der Spek <olafvdspek@gmail.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Luca Barbieri <luca.barbieri@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 27, 2010 at 1:05 PM, Ulrich Drepper <drepper@gmail.com> wrote:
> On Sat, Mar 27, 2010 at 04:50, Olaf van der Spek <olafvdspek@gmail.com> wrote:
>> It didn't 'work' for me.
>
> You still don't get it?  No shell provides you with a correct error
> message.  There is quite some work involved (reading program header,
> finding the interpreter entry, checking the file) to give a meaningful
> error message.  Changing the error code alone achieves nothing.

File not found is a very common error message with a pretty will
understood meaning. Overloading it in this way causes confusion.
Overloading another error code would avoid this confusion, especially
since it's far less used.

Olaf
