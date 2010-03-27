Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab0C0PfU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 11:35:20 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:64734 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab0C0PfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 11:35:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=nukD7oOglpCIh0ATb7YPSQZQ+y/DvjGe2nRKzF0LROKuEX3yra/gtgko7nj4eAzinu
         3u/AtULzd7fjI+W/QQRgLeqlMLwImqiO7AF172nlKUWiKn1QnfHqR2LCV85yxoDOiAn5
         KdlacgzfRoA/SbjjqEIyBxhY3SNXaULIwAuOY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: 2.6.34-rc2 breaks via82cxxx Host Protected Area
Date: Sat, 27 Mar 2010 16:34:08 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: david@fries.net, jeff@garzik.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <4BAD5472.9050303@garzik.org> <201003271119.53757.bzolnier@gmail.com> <20100327.074434.193717071.davem@davemloft.net>
In-Reply-To: <20100327.074434.193717071.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <201003271634.08054.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 March 2010 03:44:34 pm David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Sat, 27 Mar 2010 11:19:53 +0100
> 
> > The commit itself may also have a problem but since it was _never_ in
> > linux-next tree it never saw a wider upstream testing.
> 
> This is not true Bart.

Uh?  I had verified my claims before writing previous mail..

The patch ("via82cxxx: workaround h/w bugs") appeared in Linus'
tree on 19th January and it was neither in next-20100101 nor in
next-20100119.. etc.

Why?  I have no idea..  I've just noticed it today..

> My ide-2.6 and ide-next-2.6 trees are both included in
> linux-next   And if they are not, that needs to be fixed
> because they very much are intended to be.

Not my area of responsibility..

> In any event, you wrote a patch which broke something and
> if you're not willing to work on a fix I have no choice
> but to simply revert.

Please..

You picked a patch out of larger patch series posted to a mailing
list (which was clearly marked as a one for my atang tree and not
for upstream), then you merged it adding your sign-off, did poor
job w.r.t. linux-next testing phase and now I'm the one to blame
for the breakage? :)

Well, your stance on kernel project management has been already
made crystal clear during rt28xx driver discussions so I'm not
really surprised here.  I also don't remember ever signing support
contract with you or your employer so I will be putting your mails
into a separate folder (lets call it 'almost-spam') from now on..

--
Bartlomiej Zolnierkiewicz
