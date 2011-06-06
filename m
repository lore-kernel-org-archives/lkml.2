Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab1FFOYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 10:24:18 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63155 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1FFOYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 10:24:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=K6DRrge0VxNaC0oVeLALZWUkSJx+d5nMiLHvaF2CG0fl+gUgyIiZ5c1Nd25g6t341G
         eT/s3PCHiXihd37tSdYb+U+BPdLBXU/8lueMl6dllZB21qkhQvGfkrE1q9IahvCBbiuW
         BOVhOf9l8PmtAVmIkezff0Zn20HxVbooV4KqI=
MIME-Version: 1.0
In-Reply-To: <BANLkTikJJfyo-eExZYN4iZUO+RrkgPmX4A@mail.gmail.com>
References: <1306999045.29297.55.camel@pasglop>
	<1307003821.29297.77.camel@pasglop>
	<20110602110727.7343782b@lxorguk.ukuu.org.uk>
	<1307062574.29297.204.camel@pasglop>
	<1307081874.23876.14.camel@pasglop>
	<1307084189.23876.19.camel@pasglop>
	<BANLkTim6VsynZHLagcu9Xo3EjsUz=54dYA@mail.gmail.com>
	<BANLkTikJJfyo-eExZYN4iZUO+RrkgPmX4A@mail.gmail.com>
Date: Mon, 6 Jun 2011 16:24:15 +0200
Message-ID: <BANLkTi=fX8dwfZ53O7E4HX-RsL6bQ=hqWQ@mail.gmail.com>
Subject: Re: tty breakage in X (Was: tty vs workqueue oddities)
From: Guillaume Chazarain <guichaz@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, gregkh@suse.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 4:37 PM, Guillaume Chazarain <guichaz@gmail.com> wrote:
> $ while :; do date; yes | head -n 5000 | ./a.out > /dev/null; done

After reverting http://git.kernel.org/linus/a5660b4 "tty: fix endless
work loop when the buffer fills up" I cannot reproduce the hangs on
SMP anymore but it brings back the busy loop on UP.


-- 
Guillaume
