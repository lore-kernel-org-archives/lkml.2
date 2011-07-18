Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab1GRVox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 17:44:53 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46817 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab1GRVov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 17:44:51 -0400
Subject: Re: [PATCH] Add error check to hex2bin().
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-security-module@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAHp75VeQSSoW6u-LGdhoNf_mh7WP5076bpzygf710Ro8aj1+Cg@mail.gmail.com>
References: <1310977597-9666-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <201107182041.EHB78622.VOFSHFMOOFtLJQ@I-love.SAKURA.ne.jp>
	 <1310991796.3903.6.camel@smile>
	 <201107182148.AGD21306.FOLtJVMSOOFQHF@I-love.SAKURA.ne.jp>
	 <1311012230.3193.35.camel@localhost.localdomain>
	 <CAHp75VcXNQKej_n4cOB8-gYDSL8MuGrv=Fs8=zdEKGp53DCtSA@mail.gmail.com>
	 <1311016856.3648.15.camel@localhost.localdomain>
	 <CAHp75VeQSSoW6u-LGdhoNf_mh7WP5076bpzygf710Ro8aj1+Cg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 17:43:08 -0400
Message-ID: <1311025388.3648.95.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-18 at 22:44 +0300, Andy Shevchenko wrote:
> On Mon, Jul 18, 2011 at 10:20 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> >> > We probably don't need to define a separate 'safe' function.
> >> There is an opponent on any  approach. Although, small and fast error
> >> route could be good.
> 
> > As nothing but trusted/encrypted keys is using hex2bin, it shouldn't be
> > a problem.  :-)
> The key word "until now". But people will start to use anything which
> has public API, won't they?

Someone with more experience than me needs to responds.

> >  I'll update trusted/encrypted keys to check the return
> > code.
> Actually another question shall we add __must_check to the prototype or not?

Probably a good idea.

thanks,

Mimi


