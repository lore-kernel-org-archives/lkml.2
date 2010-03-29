Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab0C2O51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:57:27 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46739 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0C2O50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:57:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=SgWjfEwgtqwol0w+1bBtnmBdKrYHlT9jMj+394Z5H71BqP4OAVSwx4kYdaUF6wjROq
         k5zPxWQ9swdCKK7tH61rFLnw0pVEJbWFBnbnr7/QdgPca+NJ90kKdQ7PQIHT0V6biDi2
         Pkt0kxzexOQ37ZlPJrb1U6c++0cx9PVeQE3Cc=
MIME-Version: 1.0
In-Reply-To: <b2cc26e41003290740i5c548cabgc95d91958cd1075a@mail.gmail.com>
References: <b2cc26e41003241537h228028c4n1374f4b042175885@mail.gmail.com> 
	<g76q40hzkdcrt9mt90UYAxe124vaj_firegpg@mail.gmail.com> <b2cc26e41003251229w5d266c18gd17fdcf404136bd7@mail.gmail.com> 
	<ff13bc9a1003251400ted1993ao73c15ee86e3e717a@mail.gmail.com> 
	<a36005b51003260456m441568c1vcc8b90eed0421b9d@mail.gmail.com> 
	<ff13bc9a1003261406w7bf4bb77sf57edce14f0dcc73@mail.gmail.com> 
	<a36005b51003261415u1cc89f84r843abaa81f1d7396@mail.gmail.com> 
	<b2cc26e41003270450w1a90f9b2j5cbbae9726122b4e@mail.gmail.com> 
	<a36005b51003270505s42b5e69co14d2acbb27dc204a@mail.gmail.com> 
	<b2cc26e41003290740i5c548cabgc95d91958cd1075a@mail.gmail.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Mon, 29 Mar 2010 07:57:05 -0700
Message-ID: <a36005b51003290757v1de2e357u7478a79fa1c466a@mail.gmail.com>
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
To: Olaf van der Spek <olafvdspek@gmail.com>
Cc: Luca Barbieri <luca.barbieri@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 07:40, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> File not found is a very common error message with a pretty will
> understood meaning. Overloading it in this way causes confusion.

Again and again: this is not the message the user should ever see.  On
its own.  Once you precede it with the message about the dynamic
linker not being found and the name the ENOENT string is the right
one.
