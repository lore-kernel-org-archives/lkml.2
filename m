Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751284Ab1ECH1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 03:27:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63812 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab1ECH1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 03:27:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=lBQ5rz5SRB8NMj1Fo5fTcVHjxItu3t0p/hz5dm2LXGJovBWi7TfIr7z0vjoORrTlVg
         q8zOnkHZYPcJK95V5UlrUxt3Ipjiw1skl4K2LMXLSrB9OyPR/uRCs/5CnkJW2ZB0GKFf
         p3tePJtHiRq7yuSbxJ3oVXS7owYdX2ZbC8TYI=
Date: Tue, 3 May 2011 09:27:34 +0200
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-bluetooth@vger.kernel.org, Keith Packard <keithp@keithp.com>,
        Vinicius Gomes <vinicius.gomes@openbossa.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc2 regression: X201s fails to resume
 b77dcf8460ae57d4eb9fd3633eb4f97b8fb20716
Message-ID: <20110503092734.1c153fc3@susi.home.s3e.de>
In-Reply-To: <20110423163759.GB2323@joana>
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
	<20110423163759.GB2323@joana>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Apr 2011 13:37:59 -0300
"Gustavo F. Padovan" <padovan@profusion.mobi> wrote:

> * Keith Packard <keithp@keithp.com> [2011-04-21 17:04:51 -0700]:
> 
> > 
> > On Thu, 21 Apr 2011 19:59:53 -0300, "Gustavo F. Padovan" <padovan@profusion.mobi> wrote:
> > 
> > > Patch is on the way to mainline. It's currently on wireless-2.6. Next steps
> > > are net-2.6 -> linux-2.6.
> > 
> > I didn't see it on linux-kernel, so I was a bit worried. I'd love to
> > test it in place of the kludge that Vinicius sent me.
> 
> I usually don't cc linux-kernel in my pull-requests, maybe I should.

Did this hit mainline already? I seem to suffer from this still with -rc5
-- 
Stefan Seyfried

"Dispatch war rocket Ajax to bring back his body!"
