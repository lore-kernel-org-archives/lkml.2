Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672Ab0GHWP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 18:15:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48880 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab0GHWP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 18:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GuoL/ljhCcPiwAgXI7kFwhE80SomdFThn8T2tDzEeYIHVnLRlkVotBA14Up4pINqIM
         +4BClS2u+6JTkRkKwOJxZ1uCWPXAJ6QkaZwVuAxcTC4Ursj2c3IcLcWVjomvknvAOmmB
         czozxyfdKTBKOZq5+r/yuyzItFIqFY16kWD7k=
Subject: Re: Squid hang up on 2.6.34
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Felipe W Damasio <felipewd@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTil49m6Ul2bauiH4Pwn-6ykrYTFmSO6_SxqQgD_e@mail.gmail.com>
References: <AANLkTimn8A0cYZmwNZYitRkBHKKFe4HQ5GU626DLugkk@mail.gmail.com>
	 <AANLkTil49m6Ul2bauiH4Pwn-6ykrYTFmSO6_SxqQgD_e@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 00:08:41 +0200
Message-ID: <1278626921.2435.73.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 08 juillet 2010 à 18:30 -0300, Felipe W Damasio a écrit :
> Hi again,
> 
> Just FYI: After squid hung up, I started it again.
> 
> A few minutes later, the machine frooze...after a reboot, syslog
> didn't show any messages.
> 
> So the message below is the only tip of what happened.
> 
> Cheers,

Please try to reproduce a new report.

It looks like a memory corruption, and it would be good to see if a
common pattern is occurring.


