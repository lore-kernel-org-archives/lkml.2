Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab0IVIRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 04:17:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63260 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab0IVIRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 04:17:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH] oprofile: Add Support for Intel CPU Family 6 / Model 29
Date: Wed, 22 Sep 2010 10:17:29 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        "tdm.rhbz@gmail.com" <tdm.rhbz@gmail.com>
References: <1285053995-3811-1-git-send-email-jolsa@redhat.com> <38667ac18ee6604649af9396cf156182.squirrel@www.firstfloor.org> <20100922072633.GV13563@erda.amd.com>
In-Reply-To: <20100922072633.GV13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009221017.29202.arnd@arndb.de>
X-Provags-ID: V02:K0:awx+h20dFjd4hAcpqYUcxphx7HNCjCUbcYMR/Mv1Gcp
 YwfN6EshdsSpEV+Vc8mR2gW+w0Yg09FmATaVOHc0YvtCMaUL0x
 nR6F9Gl7Ze7oZHym0tnkHAgo+P8orlaJwhi/6dYARkgbTXA6Qa
 unAh9uPEnaBNzQwkcH51HaZXwALhArcRzWfxFyxEsga0BT9Hlt
 pT24T15iu7ZiCrEujUHKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 September 2010, Robert Richter wrote:
> On 21.09.10 10:38:04, Andi Kleen wrote:
> > > On 21.09.10 07:21:05, Arnd Bergmann wrote:
> > >> Just curious about the other missing IDs: this now supports all Core
> > >> microarchitecture CPUs, but only some Nehalem/Westmere ones.
> > >>
> > >> There is support for 0x1a (Bloomfield/Gainestown) and 0x2e (Beckton),
> > >> but
> > >> not for the much more common 0x1e (Lynnfield/Clarksfield/Jasper Forest),
> > >> 0x25 (Clarkdale/Arrandale) and 0x26 (Gulftown/Westmere-EP).
> 
> I also found reports for 0x2c (Gulftown/Westmere-EP?):
> 
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 44
> model name      : Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
> 

Right, that seems to be the correct one, I must have been looking in the
wrong place.

	Arnd
