Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab1DYClu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 22:41:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61757 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021Ab1DYClr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 22:41:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=H7E14oGoodZY/JENKDqDbwLw5ROxovjWBV7g9W3pYa4djM0c0JQhVZQ7HR4Hj2Ho+t
         cdUxa72sB2SywmXOcqhEX3CYyreBtn5jAAjVl6ZrFKvCCF3AvR03xMoTW5/mDWMwY4v4
         7tHr7dVd51hWNRaYVPprZ+0nxqFSKFDFAR6kw=
Message-ID: <4DB4DF5F.809@gmail.com>
Date: Mon, 25 Apr 2011 14:41:35 +1200
From: Michael Schmitz <schmitzmic@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux ppc; en-US; rv:1.8.1.4) Gecko/20070509 Iceape/1.1.2 (Debian-1.1.2-1)
MIME-Version: 1.0
To: Thorsten Glaser <tg@mirbsd.de>
CC: Michael Schmitz <schmitzmic@googlemail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwab@linux-m68k.org
Subject: Re: [patch] m68k, mm: set all online nodes in N_NORMAL_MEMORY
References: <1303317178.2587.30.camel@mulgrave.site> <alpine.DEB.2.00.1104201410350.31768@chino.kir.corp.google.com> <20110421220351.9180.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1104211237250.5829@chino.kir.corp.google.com> <alpine.DEB.2.00.1104211500170.5741@router.home> <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com> <alpine.DEB.2.00.1104211501470.20201@chino.kir.corp.google.com> <4DB3840F.3060503@gmail.com> <BANLkTi=vm-qs48-JySCpv+YHyC+9sO9U0A@mail.gmail.com> <Pine.BSM.4.64L.1104241131460.8787@herc.mirbsd.org>
In-Reply-To: <Pine.BSM.4.64L.1104241131460.8787@herc.mirbsd.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thorsten,
>> Tested on my ARAnyM test setup so far. I'd like to wait for an independent
>> kernel image built by Thorsten before I test on the actual hardware. Sorry but
>> you'll have to restart your build Thorsten :-)
>>     
>
> Heh okay, if you want. But only cross-compiling :D
>   
Thought so. That's fine actually. Your cross toolchain will be a lot 
more recent than mine.
>
> KOSAKI Motohiro dixit:
>
>   
>> I think you are right. however I doubt m68k need to care memoryless node check.
>> probably following patch just work.
>>     
>
> That’s what we have now. Compiles, boots, works fine.
>
>
> So, which of these do you guys want?
>   
Whatever is cleaner and easier to understand. I'm a poor judge of code 
elegance.

Cheers,

  Michael

