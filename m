Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab1JBTDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:03:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48872 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab1JBTDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:03:10 -0400
Message-ID: <4E88B549.4020008@zytor.com>
Date: Sun, 02 Oct 2011 12:02:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
References: <4E8655CD.90107@zytor.com> <201110021354.57995.rjw@sisk.pl> <4E88A537.4010008@zytor.com> <201110022014.27549.rjw@sisk.pl> <4E88AB2C.60804@zytor.com> <20111002183937.GL18690@1wt.eu>
In-Reply-To: <20111002183937.GL18690@1wt.eu>
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2011 11:39 AM, Willy Tarreau wrote:
> 
> I'm not opposed to generate a second key, but I don't really understand
> how it solves the isolation issue. I'm not used to key signing parties
> and am presently in the situation where I don't know whom to ping to
> sign my key. The only thing I could do was to sign it with my old key
> as you suggested in the initial mail on the subject :-/
> 
> So if at least generating a second key can save that hassle for next
> time, I'm all in favor of making it, it just takes a few seconds.
> 

The idea is that you have a key that you keep *extremely* secure.  When
you go to key signing parties you only bring the public key (for
verifying the fingerprint) but you don't sign keys until you're at your
secure host, for example.

That is the key you will use to establish yourself in the web of trust.
 The key you will actually *use* is a child key signed with that key,
and perhaps a handful of others.

That way, if your everyday key is compromised, you can still use your
secure key to sign the everyday key.  This alone will get you "marginal"
trust in the PGP web, which is good enough to get you new credentials.

	-hpa

