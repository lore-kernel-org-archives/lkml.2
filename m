Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab0CZSkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 14:40:20 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46576 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0CZSkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 14:40:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UCRQ+c/ZJq7iGK3F5dtozq1Y4mlst6TolI95KHn7Pqd0rHx+mCwJgilm4C45ZN+PuS
         /pm56Kkzxf4QvSHeiEXkC9TZz3d5S23sEUA/b9B2bjH/fiPmE4ro5hPi68E6GvlpV1G9
         DL3xsq8bRsNtiI99k+7igMN7PLHXq2ZBVAASs=
MIME-Version: 1.0
In-Reply-To: <a36005b51003260456m441568c1vcc8b90eed0421b9d@mail.gmail.com>
References: <b2cc26e41003241537h228028c4n1374f4b042175885@mail.gmail.com>
	 <g76q40hzkdcrt9mt90UYAxe124vaj_firegpg@mail.gmail.com>
	 <b2cc26e41003251229w5d266c18gd17fdcf404136bd7@mail.gmail.com>
	 <ff13bc9a1003251400ted1993ao73c15ee86e3e717a@mail.gmail.com>
	 <a36005b51003260456m441568c1vcc8b90eed0421b9d@mail.gmail.com>
Date: Fri, 26 Mar 2010 19:40:16 +0100
Message-ID: <b2cc26e41003261140k3b089e3esda02dd3da0aaf8a6@mail.gmail.com>
Subject: Re: execve() returns ENOENT when ld-linux.so isn't found
From: Olaf van der Spek <olafvdspek@gmail.com>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Luca Barbieri <luca.barbieri@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 12:56 PM, Ulrich Drepper <drepper@gmail.com> wrote:
> No.  ENOENT is the right value.
>
> Once again, read my first message.  The shell cannot just report the
> error anyway since there can be many different reasons for the
> problem.  If the dynamic linker is missing it has to be discovered and
> then reported.  In that message the correct error code is ENOENT.
>
> Don't try to change things which are as good as any other solution.
> The error message alone is in no case sufficient.  Fix your shells.

What about other apps that call execve?
Sounds like a lot of code duplication is needed.

Olaf
