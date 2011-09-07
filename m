Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab1IGS4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 14:56:36 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:31240 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724Ab1IGS4f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 14:56:35 -0400
Date: Wed, 7 Sep 2011 09:16:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [GIT PULL] hwmon fixes for 3.1
Message-ID: <20110907091602.56e4192b@endymion.delvare>
In-Reply-To: <CA+55aFwy-YPNHnJp6C6BRA-QfEtMoVHuxN9Uxg=p=0PwaWyXaQ@mail.gmail.com>
References: <1315325608-17922-1-git-send-email-guenter.roeck@ericsson.com>
	<CA+55aFwy-YPNHnJp6C6BRA-QfEtMoVHuxN9Uxg=p=0PwaWyXaQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Sep 2011 16:16:13 -0700, Linus Torvalds wrote:
> On Tue, Sep 6, 2011 at 9:13 AM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> >
> > Please pull hwmon subsystem fixes for Linux 3.1 from:
> >
> >    git://github.com/groeck/linux.git hwmon-for-linus
> 
> Guys, when using some general git hosting site, I really want some
> proof that you are you. Not just a "please pull".
> 
> Tell me *why* I should believe that this is a real pull request from
> the proper source. Otherwise I'll just wait until kernel.org is back
> to life, where random people can't just create repositories and send
> email.

FWIW:
* This pull request from Guenter matches the recent patch reviews on
  the lm-sensors list.
* I have reviewed the 3 patches as they exist in the mentioned
  repository and branch and they match what has been approved on the
  list.
* All the e-mail headers are exactly as I would expect from Guenter.

So while I can't guarantee that Guenter is Guenter, the pull request
definitely looks sane and safe.

-- 
Jean Delvare
