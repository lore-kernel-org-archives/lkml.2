Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128Ab2I2USQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 16:18:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52773 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab2I2USO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 16:18:14 -0400
Message-ID: <50675776.10702@zytor.com>
Date: Sat, 29 Sep 2012 13:17:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Peter Hurley <peter@hurleysoftware.com>,
        "zhenzhong.duan@oracle.com" <zhenzhong.duan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] x86: mtrr: Constrain WB MTRR to max phys mem prior to cleanup
References: <1347039854.6288.8.camel@thor> <504A3FA9.1050502@zytor.com> <504D6490.2060606@oracle.com> <1348853876.2229.22.camel@thor> <5066680E.3090907@zytor.com> <20120929104611.GB14974@khazad-dum.debian.net> <30701c46-a57e-49f2-9273-6f725c8463e0@email.android.com> <20120929201107.GB8329@khazad-dum.debian.net>
In-Reply-To: <20120929201107.GB8329@khazad-dum.debian.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Intel doesn't make it easy to get all processor specification updates at
> once so that I could hunt down every processor which acknowledges the
> existence of that errata before replying, so I will assume for the moment
> that the comment is mostly correct.
>

I should say: as far as I know the blacklist is there because noone has 
been willing to bother looking at if it actually matters, given how old 
the hardware is.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

