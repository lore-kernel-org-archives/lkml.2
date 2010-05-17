Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0EQG4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 02:56:51 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57864 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab0EQG4t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 02:56:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rIyZ99ylVL7bMrfF5Z3bIb9IopTvRf26szl5JbdJ7f4KCdNGFdfbEnQ2IkTH1yxCO9
         rUi8gUQqLF7tU3PCzw1q7U4Tq0Xx8FynAkplNJQMShe75C5rgiTi4niFG/lwsqE+iCJt
         5a3zyfxCWA2QNJcbzCm4NkC+8hCyQq+kYsu0A=
MIME-Version: 1.0
In-Reply-To: <AANLkTikD7M_PKH3YgOWIvrcD6aW6X-gYIo2iw52QRRq_@mail.gmail.com>
References: <AANLkTikD7M_PKH3YgOWIvrcD6aW6X-gYIo2iw52QRRq_@mail.gmail.com>
Date: Mon, 17 May 2010 12:26:35 +0530
Message-ID: <AANLkTimrW2sMUcLGOAgC6h1JA-ZgzX23X3bbbyzh_Mrr@mail.gmail.com>
Subject: Re: Which function returns LWP in Linux.
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Srinivas Nayak <sinu.nayak2001@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 17, 2010 at 11:57 AM, Srinivas Nayak
<sinu.nayak2001@gmail.com> wrote:
> Hi,
>
> For a process, we have different PIDs. For threads under a single
> processes, we have different LWP id, but same PID in Linux.
> ex.
>
> root@pc:/home/srinivas# ps -eLf
> UID        PID  PPID     LWP  C STIME       TIME     CMD
> root       100     1     100  0 May13       00:00:02 ./a.out
> root       100     1     102  0 May13       00:00:00 ./a.out
>
> getpid() function returns PID of a process.
> Which function retuns LWP id for thread?
>

You are asking procps question in LKML.

Please check http://procps.sourceforge.net/

Download propps package, read source code and you will get the reply.

Thanks,
--
Jaswinder Singh.
