Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1FNVLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 17:11:32 -0400
Received: from mx3.utsp.utwente.nl ([130.89.2.14]:53807 "EHLO mx.utwente.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab1FNVLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 17:11:30 -0400
Date: Tue, 14 Jun 2011 23:11:09 +0200 (CEST)
From: Martijn Uffing <mp3project@sarijopen.student.utwente.nl>
To: Jeff Layton <jlayton@redhat.com>
cc: Connor Hansen <cmdkhh@gmail.com>, Suresh Jayaraman <sjayaraman@suse.de>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean finney <seanius@seanius.net>,
        Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [OOPS] 3.0-rc1 cifs
In-Reply-To: <20110613114831.37c90109@tlielax.poochiereds.net>
Message-ID: <Pine.LNX.4.64.1106142233270.23723@sarijopen.student.utwente.nl>
References: <Pine.LNX.4.64.1106092211500.19687@sarijopen.student.utwente.nl>
 <20110609183045.01f6f9fc@tlielax.poochiereds.net>
 <BANLkTimPqmkNJMaJE2_C5zD8ESFOEM3=hg@mail.gmail.com>
 <Pine.LNX.4.64.1106100243370.2168@sarijopen.student.utwente.nl>
 <20110610073702.061bc014@corrin.poochiereds.net>
 <BANLkTinqT0AXx9STWEzrw-yASTid5rb1Fg@mail.gmail.com> <4DF20A97.8010405@suse.de>
 <BANLkTimAauVsqX1JZucG1cg3-MAtqCrZFQ@mail.gmail.com>
 <20110611074113.5a05f919@tlielax.poochiereds.net>
 <Pine.LNX.4.64.1106112356500.12565@sarijopen.student.utwente.nl>
 <20110613114831.37c90109@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-UTwente-MailScanner-Information: Scanned by MailScanner. Contact icts.servicedesk@utwente.nl for more information.
X-UTwente-MailScanner: Found to be clean
X-UTwente-MailScanner-From: mp3project@sarijopen.student.utwente.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (cc'ing Pavel)
>
> Ok, I've been able to reproduce on -rc2 as well, simply by mounting
> with -o sec=none. Pavel, I'm pretty sure this got broken by commit
> 724d9f1cfb. That patch doesn't handle the "null user" case correctly.
> There are probably several different ways to fix it:
>

Ave all

Just to confirm the OOPS/BUG is still present in 3.0-rc3

3.0-rc3                  -> same OOPS as in rc1
3.0-rc3+ Jeff's patch    -> same BUG as in rc1

Can I be helpful with further testing by cranking up some more debugging 
options in the kernel hacking section of "make menuconfig", or is the 
cause of the OOPS/BUG clear enough?

Martijn





