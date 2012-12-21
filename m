Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab2LUWzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 17:55:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39528 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab2LUWy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 17:54:59 -0500
Message-ID: <50D4E8A9.4090700@zytor.com>
Date: Fri, 21 Dec 2012 14:54:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jan Kiszka <jan.kiszka@web.de>, Jason Wessel <jason.wessel@windriver.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/13] x86, 64bit: Set extra ident mapping for whole
 kernel range
References: <1354089042-10023-1-git-send-email-yinghai@kernel.org> <1354089042-10023-4-git-send-email-yinghai@kernel.org> <20121221222840.GB1102@phenom.dumpdata.com> <CAE9FiQWXz1xtgbAocvgXKigKJS1Yqr_CPdiLm4N6=PrUxkoPMg@mail.gmail.com> <50D4E515.5070802@zytor.com> <CAE9FiQUvZCyLgV=x19J0ssYZxdZJ7fTsf=3s-yaLUB9HXqg+rg@mail.gmail.com>
In-Reply-To: <CAE9FiQUvZCyLgV=x19J0ssYZxdZJ7fTsf=3s-yaLUB9HXqg+rg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 02:51 PM, Yinghai Lu wrote:
>
> looks like no one care about kgdb now.
> hope they could notice until that is broken later.
>

It's late December -- people are off.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

