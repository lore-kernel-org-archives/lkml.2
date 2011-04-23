Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1DWQhl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 12:37:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34711 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076Ab1DWQhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 12:37:39 -0400
Date: Sat, 23 Apr 2011 13:37:59 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Keith Packard <keithp@keithp.com>
Cc: Vinicius Gomes <vinicius.gomes@openbossa.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: Re: 2.6.39-rc2 regression: X201s fails to resume
 b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
Message-ID: <20110423163759.GB2323@joana>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Vinicius Gomes <vinicius.gomes@openbossa.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-bluetooth@vger.kernel.org
References: <yun1v1fj024.fsf@aiko.keithp.com>
 <alpine.LFD.2.00.1104070022280.3971@localhost6.localdomain6>
 <alpine.LFD.2.00.1104082340020.2724@localhost6.localdomain6>
 <yunaag0tjzb.fsf@aiko.keithp.com>
 <20110409000857.GB25581@piper>
 <20110411173409.1567679c@lxorguk.ukuu.org.uk>
 <BANLkTinK-cA67X6Knp-h5SKpjpDpwaMgZg@mail.gmail.com>
 <yunaafjs28n.fsf@aiko.keithp.com>
 <20110421225953.GA2323@joana>
 <yun62q7i21o.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yun62q7i21o.fsf@aiko.keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Keith Packard <keithp@keithp.com> [2011-04-21 17:04:51 -0700]:

> 
> On Thu, 21 Apr 2011 19:59:53 -0300, "Gustavo F. Padovan" <padovan@profusion.mobi> wrote:
> 
> > Patch is on the way to mainline. It's currently on wireless-2.6. Next steps
> > are net-2.6 -> linux-2.6.
> 
> I didn't see it on linux-kernel, so I was a bit worried. I'd love to
> test it in place of the kludge that Vinicius sent me.

I usually don't cc linux-kernel in my pull-requests, maybe I should.

-- 
Gustavo F. Padovan
http://profusion.mobi
