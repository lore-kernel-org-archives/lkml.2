Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab1JOXET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 19:04:19 -0400
Received: from nef2.ens.fr ([129.199.96.40]:3882 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab1JOXES convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 19:04:18 -0400
From: =?utf-8?q?=C3=89ric_Brunet?= <Eric.Brunet@lps.ens.fr>
Organization: UPMC LPS-ENS
To: Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: Fw: List corruption and crash with kernel 3.1
Date: Sun, 16 Oct 2011 01:04:00 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39p+; KDE/4.6.5; x86_64; ; )
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, tiwai@suse.de, linux-pm@vger.kernel.org
References: <20111011162500.db7cd65f.akpm@linux-foundation.org> <1318410972.23801.143.camel@ted> <20111013155002.GA10632@oksana.dev.rtsoft.ru>
In-Reply-To: <20111013155002.GA10632@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201110160104.01022.Eric.Brunet@lps.ens.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Sun, 16 Oct 2011 01:04:03 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 13 octobre 2011 17:50:02, Anton Vorontsov a écrit :
> Resend, add proper Cc's.
> 
> On Wed, Oct 12, 2011 at 10:16:08AM +0100, Richard Purdie wrote:
> > On Tue, 2011-10-11 at 16:25 -0700, Andrew Morton wrote:
> > > erk, help, who do I blame for this?
> > 
> > [...]
> > 
> > > WARNING: at lib/list_debug.c:47 __list_del_entry+0x8d/0x98()
> 
> I wonder if that patch helps:
> 
> https://lkml.org/lkml/2011/7/12/242
> 
> The traces are pretty similar.

Hi,

Sorry it took some time. I tried the patch with 2.6.39, it does not seem to 
help as I still observe the crash. I was not gifted with a warning in the 
logs, though.

(I used 2.6.39 because it's a kernel with a quite high rate of bugging on 
suspend/resume. I had to apply manually one of the chunks of the patch.)

Is there a debugging option which would help having more info on the log ?

Thanks,

	Éric Brunet
