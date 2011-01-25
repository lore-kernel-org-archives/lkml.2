Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1AYJRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 04:17:19 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:53677 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751708Ab1AYJRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 04:17:17 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX190s/oSQat0B+c5pP3OW2xqW+Aegd3wSFsktClXNB
	RBmpykM1kbXjtc
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: libata EH running when switching VTs
Date: Tue, 25 Jan 2011 10:17:12 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>,
        Jens Rutschmann <Jens.Rutschmann@gmx.info>
References: <201101221625.00775.toralf.foerster@gmx.de> <201101221831.09448.toralf.foerster@gmx.de> <4D3E2612.2060808@gmail.com>
In-Reply-To: <4D3E2612.2060808@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101251017.13164.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Robert Hancock wrote at 02:23:30
> On 01/22/2011 11:31 AM, Toralf Förster wrote:
> >>> I'm wondering why I get this in /var/log/messages w/ kernel 2.6.37 when
> >>> I switch from VT7 (running xorg ) to VT12 (or 1 or 2 or another
> >>> number) and back:
> Curious, there seems to be no indication of why EH was triggered,
> doesn't seem to be have been due to an error. Does this also happen in
> single-user mode or with minimal processes running? It's possible that
> userspace is triggering this somehow.

It happens only, when I switch to the VT7 _and_ X is running there.
It dos not happen when switching  only between straight consoles like from VT1 
to VT2 or so.

BTW I Cc'ed Jens which have a similar problem with his ThinkPad T61:

>Hi Toralf,
>
>I saw lines similar to yours as well on my T61 during boot. It does not occur 
>when switching VTs.
>
>When I switch VTs as you described I get this in dmesg though:
>
>[  491.372673] ata1.00: configured for UDMA/133
>[  491.372677] ata1: EH complete
>[  491.680387] EXT4-fs (sda1): re-mounted. Opts: discard,commit=0
>[  491.683110] EXT4-fs (sda3): re-mounted. Opts: discard,commit=0
>
>This is with a vanilla 2.6.37

-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

