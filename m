Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab1DXFFW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 01:05:22 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:48665 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab1DXFFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 01:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=E0DAAayIpafQ291uwoSj7r3eGtPB/rFCdCLNl98uSC3JXcFlTb6Neo5m0AT5SR9Wey
         LaLnZrp9nQgn1qZF8QiUqkEz9zV0Msnm6XJ2ag7tCpGKZGK35TXISQ4FmEMXiKaYfk/T
         oDA617l1yCOrmRs/J9MfDKzmZL7zSepNL3ovE=
Message-ID: <4DB3AF8B.6020105@gmail.com>
Date: Sun, 24 Apr 2011 17:05:15 +1200
From: Michael Schmitz <schmitzmic@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux ppc; en-US; rv:1.8.1.4) Gecko/20070509 Iceape/1.1.2 (Debian-1.1.2-1)
MIME-Version: 1.0
To: Michael Schmitz <schmitzmic@googlemail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwab@linux-m68k.org,
        "tg@mirbsd.de >> Thorsten Glaser" <tg@mirbsd.de>
Subject: Re: [patch] m68k, mm: set all online nodes in N_NORMAL_MEMORY
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com> <20110421220351.9180.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com> <alpine.DEB.2.00.1104211500170.5741@router.home> <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com> <alpine.DEB.2.00.1104211501470.20201@chino.kir.corp.google.com> <4DB3840F.3060503@gmail.com> <BANLkTi=vm-qs48-JySCpv+YHyC+9sO9U0A@mail.gmail.com> <4DB3A09A.70308@gmail.com>
In-Reply-To: <4DB3A09A.70308@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Schmitz wrote:
> Besides, your solution would set N_HIGH_MEMORY not N_NORMAL_MEMORY if 
> I read free_area_init_nodes() right. Does that matter?
check_for_regular_memory() does take care of that - so it would be all 
the same in the end. Whether it's worth it for a handful of nodes at 
best I'm unsure. I'll leave that for Geert to decide.

Cheers,

  Michael

