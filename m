Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0EHLVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 07:21:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39576 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab0EHLVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 07:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=ZoZwn9Bq9FJJaorkMCiVAZsFtetM+BiRivYTtp1fA1jjLuAer6Y7Xq1Q6Q+4azwLMC
         zs602exU3o88Dg3Xa0jB6tYhveuYsnhMGFxi+CQmC5BLAe3N8biz7iVZuNxKu2weAgCc
         pBFER70mpnnKCCiqHS/9dIeg4HUXXNr3tq+t0=
MIME-Version: 1.0
In-Reply-To: <m2ze31aef501005080415t3b43f92exc1abda4b34d92992@mail.gmail.com>
References: <m2ze31aef501005080415t3b43f92exc1abda4b34d92992@mail.gmail.com>
From: Henrik Kjellberg <et05hk6@gmail.com>
Date: Sat, 8 May 2010 13:20:56 +0200
Message-ID: <u2ie31aef501005080420sbd52df3dufed90b9d11e94d7c@mail.gmail.com>
Subject: Re: Partial Array Self-Refresh on linux embedded systems
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have done my master thesis on the subject of Partial Array
Self-refresh in an embedded Linux environment at STEricsson. I have
now finished my thesis, started working and has verry little time
(read: no time) to spend on Linux hacking. There fore I would like to
pass my work on, in hope that someone else will find it interesting
and worth puting som effort in.

One of the greatest challenges in mobile systems, like cell-phones, is
battery time. All unnecessary power consumers of a mobile system have
to be minimized. One such consumer is the dynamic memory. Dynamic
Random Access Memory (DRAM), is a volatile memory, where every bit of
memory consists of a capacitor and a transistor. When the capacitor is
charged, the bit is set to one, and when it is uncharged, the bit is
set to zero.
 The main advantage with the construction is that only two components
are needed, which leads to a high memory density on the chip.
The disadvantage is the physical properties of a capacitor as a
component. The physical capacitor has leak currents, which drains the
capacitor. The leakage itself does not lead to noticeable losses, but
the data will get corrupted unless it is constantly refreshed by
recharging the capacitor. The recharging is done by reading out and
writing back all the data of the memory.
 During normal operation, the refresh is handled by the operating
system. When in idle mode, on the other hand, the refresh is done by
the memory itself, in a so called self-refresh mode, since the
processor is powered down. To refresh the whole memory if only a part
of it is in use is a super uous waste of power. That is why Partial
Array Self-refresh (PASR) was introduced.
There is no software implementation making use of PASR in the Linux
kernel as of today. The article is based on my master thesis, which
aims to present a possible implementation of PASR and evaluate its e
ciency.

An article summarizing what I have done is found below:
http://sam.cs.lth.se/ExjobGetFile?id=240

Best regards
Henrik Kjellberg
