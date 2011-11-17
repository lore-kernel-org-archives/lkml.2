Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab1KQQGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:06:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40161 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab1KQQGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:06:47 -0500
Message-ID: <4EC53105.4050301@zytor.com>
Date: Thu, 17 Nov 2011 08:06:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 3/5] x86: add a sysctl parameter to panic on stack
 overflow
References: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp> <20111107055301.7928.91628.stgit@ltc219.sdl.hitachi.co.jp> <20111110195538.GB22646@phenom.dumpdata.com> <4EC4B38B.2010301@hitachi.com> <20111117160021.GC6008@phenom.dumpdata.com>
In-Reply-To: <20111117160021.GC6008@phenom.dumpdata.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 08:00 AM, Konrad Rzeszutek Wilk wrote:
>>
>> I don't mind if I add __read_mostly here, but I think it's not
>> necessary because this variable is seldom read as well.
> 
> The definition of __read_mostly is that it moves this variable to a cold cache area.
> Which is what you want.
> 

Not really.  __read_mostly moves a variable to an area that is expected
to spent most its time in the cache-shared state and rarely be
invalidated.  It does NOT mean that it is cold.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

