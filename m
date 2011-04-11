Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab1DKQNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 12:13:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:52155 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab1DKQNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 12:13:17 -0400
Date: Mon, 11 Apr 2011 18:13:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
cc: Keith Packard <keithp@keithp.com>,
        Vinicius Costa Gomes <vinicius.gomes@openbossa.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: Re: 2.6.39-rc2 regression: X201s fails to resume
 b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
In-Reply-To: <20110411155826.GA2195@joana>
Message-ID: <alpine.LFD.2.00.1104111812310.4501@localhost6.localdomain6>
References: <yun1v1fj024.fsf@aiko.keithp.com> <alpine.LFD.2.00.1104070022280.3971@localhost6.localdomain6> <alpine.LFD.2.00.1104082340020.2724@localhost6.localdomain6> <yunaag0tjzb.fsf@aiko.keithp.com> <20110409000857.GB25581@piper> <yunipuouqoi.fsf@aiko.keithp.com>
 <20110411155826.GA2195@joana>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011, Gustavo F. Padovan wrote:

> * Keith Packard <keithp@keithp.com> [2011-04-08 19:03:25 -0700]:
> 
> > On Fri, 8 Apr 2011 21:08:57 -0300, Vinicius Costa Gomes <vinicius.gomes@openbossa.org> wrote:
> > 
> > > I took a shot at it and just sent a patch (also attached for convenience) 
> > > that should solve the problem.
> > 
> > Thanks much! I applied this to -rc2 and it appears to work fine in some
> > brief testing (a dozen suspend/resume cycles)
> > 
> > > Reported-by: Keith Packard <keithp@keithp.com>
> > > Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
> > 
> > Tested-by: Keith Packard <keithp@keithp.com>
> 
> I applied the patch to bluetooth-2.6. Thank you all.

Sigh. Is actually anyone trying to read what I wrote ?
