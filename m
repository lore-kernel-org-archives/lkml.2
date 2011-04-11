Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1DKP57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 11:57:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45663 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab1DKP55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 11:57:57 -0400
Date: Mon, 11 Apr 2011 12:58:26 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Keith Packard <keithp@keithp.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org
Subject: Re: 2.6.39-rc2 regression: X201s fails to resume
 b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
Message-ID: <20110411155826.GA2195@joana>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Vinicius Costa Gomes <vinicius.gomes@openbossa.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-bluetooth@vger.kernel.org
References: <yun1v1fj024.fsf@aiko.keithp.com>
 <alpine.LFD.2.00.1104070022280.3971@localhost6.localdomain6>
 <alpine.LFD.2.00.1104082340020.2724@localhost6.localdomain6>
 <yunaag0tjzb.fsf@aiko.keithp.com>
 <20110409000857.GB25581@piper>
 <yunipuouqoi.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yunipuouqoi.fsf@aiko.keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Keith Packard <keithp@keithp.com> [2011-04-08 19:03:25 -0700]:

> On Fri, 8 Apr 2011 21:08:57 -0300, Vinicius Costa Gomes <vinicius.gomes@openbossa.org> wrote:
> 
> > I took a shot at it and just sent a patch (also attached for convenience) 
> > that should solve the problem.
> 
> Thanks much! I applied this to -rc2 and it appears to work fine in some
> brief testing (a dozen suspend/resume cycles)
> 
> > Reported-by: Keith Packard <keithp@keithp.com>
> > Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
> 
> Tested-by: Keith Packard <keithp@keithp.com>

I applied the patch to bluetooth-2.6. Thank you all.


-- 
Gustavo F. Padovan
http://profusion.mobi
