Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab1JBT1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:27:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43250 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab1JBT0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:26:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: kernel.org status: establishing a PGP web of trust
Date: Sun, 2 Oct 2011 21:29:11 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Willy Tarreau <w@1wt.eu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
References: <4E8655CD.90107@zytor.com> <20111002183937.GL18690@1wt.eu> <4E88B549.4020008@zytor.com>
In-Reply-To: <4E88B549.4020008@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110022129.11820.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 02, 2011, H. Peter Anvin wrote:
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

OK, call the "extremely secure" key pair a "master".  So, in practice I'll only
take the master and child public keys (the child key signed with the master)
with me to the KS.  At the KS I'll collect the IDs and fingerprints of
people's keys to sign and I'll sign them, with the master key, when I'm back
at my secure host.  I also give my public keys (both master and child) to
people for signing.

Is this what you mean?

Rafael
