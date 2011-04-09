Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017Ab1DIBsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 21:48:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53076 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757986Ab1DIBr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 21:47:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:date:from:to:cc:message-id:in-reply-to:references;
        b=OUgFYcgNgjXpZXIkCmO1MYqEowZ2MNQBAdXnVNIjgWgaDSiicBrCzRT38AH2Pojl5I
         j9kL9SjT2VP3quxUwcPluJHk+JEmUxR9UPcL4HRSPpnWSrrDVkWPEbhxjB85v6kch8+P
         oxUtM2W8ZWofnFvRTT3eHCbwYD9u74nUeE72k=
Subject: Re: [PATCH] Use the environment variable PYTHON if defined
Date: Sat, 9 Apr 2011 01:24:57 +0000
From: Michael Witten <mfwitten@gmail.com>
To: Raghavendra D Prabhu <rprabhu@wnohang.net>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Message-ID: <5f5948dd-2c38-4ed3-8544-99c137204d07-mfwitten@gmail.com>
In-Reply-To: <20110408211709.GA5155@Xye>
References: <20110326224408.GA1336@Xye>
            <20110328144721.GB17872@ghostprotocols.net>
            <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
            <20110329181524.GA5140@Xye>
            <AANLkTi=3Wq3Xt-QFR-FLRQ1kBjpWjaBZNFpOiE_T15WH@mail.gmail.com>
            <20110329204024.GA20824@ghostprotocols.net>
            <3a97df19-e376-412a-95be-37ffde765cc3-mfwitten@gmail.com>
            <20110408211709.GA5155@Xye>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Apr 2011 02:47:09 +0530, Raghavendra D Prabhu wrote:

> Apologies for the delay. I am getting a merge conflict
> with master now, it may need to be rebased after the
> 1b7155f7de119870f0d3fad89f125de2ff6c16be commit.

Erg... `git am' isn't really any help there, as it doesn't
leave information in the files about where there are conflicts;
I had to resort to running `git merge' by hand.

Anyway, I've sent along (as replies to this email) *2* patches;
the first one:

  perf tools: Makefile: Clean up `python/perf.so' rule

is just a minor tweak of the offending conflict, and the second
one is the updated patch proper:

  perf tools: Makefile: PYTHON{,_CONFIG} to bandage Python 3 incompatibility

They should apply cleanly on Arnaldo's `perf/urgent' branch from
his repository here:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6.git

the tip of which contains the commit you mentioned:

  1b7155f7de119870f0d3fad89f125de2ff6c16be

Arnaldo, is it generally a good idea to branch from `perf/urgent'
in order to keep things up to date?

Sincerely,
Michael Witten
