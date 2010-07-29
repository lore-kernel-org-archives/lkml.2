Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab0G2L0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 07:26:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51162 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab0G2L0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 07:26:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y6XlBAyOec3k8nXGGbs9WSrYFLG7O3vB+3oOh98xkoWuKFFZ2IVL7drOct4mBrw4/c
         M0HLgdANauKSk5HW8WmJT0Z0Fp/mqsn97VALERxhsIU2yjDi51lPR+Q12JUvCuibnt9C
         ezd3Y5bY7a4zvxJiIdTtVjZrxFYO06TqISwkc=
MIME-Version: 1.0
In-Reply-To: <20100729105225.GA13192@faui48a.informatik.uni-erlangen.de>
References: <20100729105225.GA13192@faui48a.informatik.uni-erlangen.de>
Date: Thu, 29 Jul 2010 19:26:00 +0800
Message-ID: <AANLkTi=cYgV69VyNZ+TKs_f-+3AJmyo_RaYS57R72j50@mail.gmail.com>
Subject: Re: Bus error on make allyesconfig, kernelbuild with HEAD
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 6:52 PM, Christoph Egger <siccegge@cs.fau.de> wrote:
> Hi all!
>
>    Building the linux kernel, as well as doing a"make allyesconfig"
> on a fresh checkout of linux HEAD results in the same Bus Error in
> fixdep (details below). This is a i5 box running 32bit Ubuntu Lucid
> with plenty of (free) RAM. Haven't found any hints to what might be
> wrong on scanning over the web archives.
>
> Regards
>
>    Christoph
>
> -----
>  % make allyesconfig
>  HOSTCC  scripts/basic/fixdep
> fixdep: mmap: Cannot allocate memory

So what does 'ls -lh scripts/basic/.fixdep.d' say?
Seems this file is too big...
