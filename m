Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab1JBTY5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:24:57 -0400
Received: from 1wt.eu ([62.212.114.60]:33391 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308Ab1JBTYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:24:53 -0400
Date: Sun, 2 Oct 2011 21:24:49 +0200
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111002192449.GM18690@1wt.eu>
References: <4E8655CD.90107@zytor.com> <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com> <201110022014.27549.rjw@sisk.pl> <4E88AB2C.60804@zytor.com> <20111002183937.GL18690@1wt.eu> <4E88B549.4020008@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E88B549.4020008@zytor.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 12:02:33PM -0700, H. Peter Anvin wrote:
> On 10/02/2011 11:39 AM, Willy Tarreau wrote:
> > 
> > I'm not opposed to generate a second key, but I don't really understand
> > how it solves the isolation issue. I'm not used to key signing parties
> > and am presently in the situation where I don't know whom to ping to
> > sign my key. The only thing I could do was to sign it with my old key
> > as you suggested in the initial mail on the subject :-/
> > 
> > So if at least generating a second key can save that hassle for next
> > time, I'm all in favor of making it, it just takes a few seconds.
> > 
> 
> The idea is that you have a key that you keep *extremely* secure.  When
> you go to key signing parties you only bring the public key (for
> verifying the fingerprint) but you don't sign keys until you're at your
> secure host, for example.
> 
> That is the key you will use to establish yourself in the web of trust.
>  The key you will actually *use* is a child key signed with that key,
> and perhaps a handful of others.
> 
> That way, if your everyday key is compromised, you can still use your
> secure key to sign the everyday key.  This alone will get you "marginal"
> trust in the PGP web, which is good enough to get you new credentials.

OK that makes sense. Thanks for the explanation.

Willy

