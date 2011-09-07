Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab1IGS4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:56:35 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:30006 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab1IGS4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:56:33 -0400
Date: Wed, 7 Sep 2011 09:28:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [GIT PULL] hwmon fixes for 3.1
Message-ID: <20110907092816.4634b657@endymion.delvare>
In-Reply-To: <20110907014725.GC22609@ericsson.com>
References: <1315325608-17922-1-git-send-email-guenter.roeck@ericsson.com>
	<CA+55aFwy-YPNHnJp6C6BRA-QfEtMoVHuxN9Uxg=p=0PwaWyXaQ@mail.gmail.com>
	<20110907014725.GC22609@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Sep 2011 18:47:25 -0700, Guenter Roeck wrote:
> On Tue, Sep 06, 2011 at 07:16:13PM -0400, Linus Torvalds wrote:
> > Guys, when using some general git hosting site, I really want some
> > proof that you are you. Not just a "please pull".
> > 
> > Tell me *why* I should believe that this is a real pull request from
> > the proper source. Otherwise I'll just wait until kernel.org is back
> > to life, where random people can't just create repositories and send
> > email.
> 
> sorry, I didn't think that far. You are absolutely right. No idea if and how
> I can prove that I am me. Generate a PGP signature ? Can't everyone do that 
> and subsequently claim to be me ? All I represent (technically) is an account
> on kernel.org, which might not even exist anymore.

When you created this account on kernel.org, you used a PGP key to
identify yourself, didn't you? If you sign your message with that key,
then a few people (basically the kernel.org maintainers) will be able
to confirm that you are the same person who had a trusted kernel.org
account. I don't know if Linus has the list though.

What surprises me a little is that I don't have your public key in my
keyring, and I can't seem to be able to find it on public servers
either. You really should push your key to public key servers,
otherwise a signed message from you has no value in general.

Obviously it's a little late now though. The whole idea of trust and
signatures is to keep the level of trust after odd events such as the
kernel.org break-in. For this, keys must have been exchanged, tested
and trusted long before said event happens.

> (...)
> The fixes are not that important and can wait. Please ignore my pull request;
> I'll re-send it after kernel.org is up and running again.

It's getting long :( I wonder how much more time it will take.

-- 
Jean Delvare
