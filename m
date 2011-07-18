Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab1GRTod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 15:44:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55387 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1GRTob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 15:44:31 -0400
MIME-Version: 1.0
In-Reply-To: <1311016856.3648.15.camel@localhost.localdomain>
References: <1310977597-9666-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<201107182041.EHB78622.VOFSHFMOOFtLJQ@I-love.SAKURA.ne.jp>
	<1310991796.3903.6.camel@smile>
	<201107182148.AGD21306.FOLtJVMSOOFQHF@I-love.SAKURA.ne.jp>
	<1311012230.3193.35.camel@localhost.localdomain>
	<CAHp75VcXNQKej_n4cOB8-gYDSL8MuGrv=Fs8=zdEKGp53DCtSA@mail.gmail.com>
	<1311016856.3648.15.camel@localhost.localdomain>
Date: Mon, 18 Jul 2011 22:44:29 +0300
Message-ID: <CAHp75VeQSSoW6u-LGdhoNf_mh7WP5076bpzygf710Ro8aj1+Cg@mail.gmail.com>
Subject: Re: [PATCH] Add error check to hex2bin().
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-security-module@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 10:20 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

>> > We probably don't need to define a separate 'safe' function.
>> There is an opponent on any  approach. Although, small and fast error
>> route could be good.

> As nothing but trusted/encrypted keys is using hex2bin, it shouldn't be
> a problem.  :-)
The key word "until now". But people will start to use anything which
has public API, won't they?

>  I'll update trusted/encrypted keys to check the return
> code.
Actually another question shall we add __must_check to the prototype or not?

-- 
With Best Regards,
Andy Shevchenko
