Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab2HXSfo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:35:44 -0400
Received: from mail1-hoer.fullrate.dk ([89.150.129.84]:57677 "EHLO
	smtp.fullrate.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757955Ab2HXSfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:35:41 -0400
From: Martin Nybo Andersen <tweek@tweek.dk>
To: wbrana <wbrana@gmail.com>
Subject: Re: Drop support for x86-32
Date: Fri, 24 Aug 2012 20:35:38 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc1+; KDE/4.8.4; x86_64; ; )
Cc: Chris Friesen <chris.friesen@genband.com>,
        Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Ondrej Zary <linux@rainbow-software.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208241952.04988.tweek@tweek.dk> <CAJ7jCmmKBMahT=MdR4D=3zTCZ=-_fxKnydrCo1eW45sFPoAFZw@mail.gmail.com>
In-Reply-To: <CAJ7jCmmKBMahT=MdR4D=3zTCZ=-_fxKnydrCo1eW45sFPoAFZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208242035.38733.tweek@tweek.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2012 20:18:49 wbrana wrote:
> On 8/24/12, Martin Nybo Andersen <tweek@tweek.dk> wrote:
> > That's right, but new hardware, that I wish to use with the old machines
> > might
> > not because of no backporting of new drivers. Same goes for new software
> > utilising newer kernel features.
> 
> Which new hardware and which old machine do you want to use?
I want to use *my* old machines (hey, I payed for them) on whatever new 
hardware I can plug into them. I'm not an oracle and can't see into the 
future, however USB has evolved, for instance, and will probably still do -- 
requiring new drivers as before.

> > Those mentioned by Chris Friesen, whose arguments you apparently ignored.
> 
> I can't find any e-mail where Chris Friesen mentioned exact legacy apps.
Have a look in your inbox or one of the mailarchives. If that doesn't work, 
then stop deleting half of the mails before replying.

> > You are allowed to compile most of the software running on Linux
> > yourself. If
> > you want a binary to use the x32 ABI, go compile.
> 
> I can't compile x32 versions of Firefox, Chromium, NVIDIA drivers, etc.
The source code for Firefox and Chromium is available online. Go fetch and 
compile. If they don't compile or execute as intended, I'm sure they would 
like seeing a patch from you fixing the problem.

NVIDIA, on the other hand, is yet another reason for using nouveau.

-- 
Cheers,
Martin
