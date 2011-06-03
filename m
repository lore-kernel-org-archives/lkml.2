Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1FCQoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 12:44:19 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:58392 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab1FCQoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 12:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wKJFp6Ad0pj0B1x4nWrXSyyHXRSIrDa2fv7K6Bq3zmiho06aJ4W77RqYU28n754/oU
         Ac7uApm+RQSQlNLsYQxgNuPjSWrSG1aufx3SjPj0G+b9HjnQXA796wJLqtXOvmdfsXrR
         usS+0Ch0M1jLp2RyU73ADptf6tsaHvtgygYIg=
MIME-Version: 1.0
In-Reply-To: <20110603143824.GA3138@elliptictech.com>
References: <20110602182431.GA26282@rhlx01.hs-esslingen.de>
	<20110603143824.GA3138@elliptictech.com>
Date: Fri, 3 Jun 2011 12:44:16 -0400
Message-ID: <BANLkTikOPn-MF08QVyeY3F7mexDyp47pog@mail.gmail.com>
Subject: Re: Heads-up: Linux make menuconfig .config vs. XDG_CONFIG_HOME
 ~/.config/ clash - perhaps resolve it while 3.0 appears?
From: Arnaud Lacombe <lacombar@gmail.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Andreas Mohr <andi@lisas.de>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
        Michal Marek <mmarek@suse.cz>, Waldo Bastian <bastian@kde.org>,
        Ryan Lortie <desrt@desrt.ca>,
        Lennart Poettering <lennart@poettering.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 3, 2011 at 10:38 AM, Nick Bowler <nbowler@elliptictech.com> wrote:
> Renaming the .config file is obviously going to cause a lot of pain, and
> there seems to be very little gain.
>
For the record, it is already possible to rename the config file
through the KCONFIG_CONFIG environment variable:

Documentation/kbuild/kconfig.txt:

KCONFIG_CONFIG
--------------------------------------------------
This environment variable can be used to specify a default kernel config
file name to override the default name of ".config".

 - Arnaud
