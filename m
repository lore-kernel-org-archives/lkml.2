Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab1LGAMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 19:12:23 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54648 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab1LGAMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 19:12:22 -0500
MIME-Version: 1.0
In-Reply-To: <20111206232741.GA5368@x1.osrc.amd.com>
References: <20111206232741.GA5368@x1.osrc.amd.com>
Date: Tue, 6 Dec 2011 19:12:21 -0500
Message-ID: <CA+5PVA7bM8ZGaCiyZdHcMVccJYh2=bk-gsHLo9ZmBP_SYT208w@mail.gmail.com>
Subject: Re: atl1c: WARNING: at net/sched/sch_generic.c:255 dev_watchdog
From: Josh Boyer <jwboyer@gmail.com>
To: Borislav Petkov <bp@alien8.de>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 6:27 PM, Borislav Petkov <bp@alien8.de> wrote:
> Hi,
>
> this seems like a pretty old issue judging by a quick net search. It
> still triggers on latest -rc4 here, below the whole trace. I'm willing
> to test patches :).
>
> [14622.820555] atl1c 0000:02:00.0: atl1c: eth0 NIC Link is Up<100 Mbps Full Duplex>
> [14632.816280] ------------[ cut here ]------------
> [14632.816314] WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0x237/0x240()
> [14632.816323] Hardware name: 30515QG
> [14632.816332] NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out

Matthew Garrett has a patch to the atl1c driver that changed it's ASPM
behavior that seemed to help.  Dave Miller applied it, but I don't see
it in linux-next for some reason.

http://comments.gmane.org/gmane.linux.kernel/1214694


josh
