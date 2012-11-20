Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2KTOSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:18:14 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:40498 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2KTOSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:18:12 -0500
Message-ID: <50AB9116.3090401@synopsys.com>
Date: Tue, 20 Nov 2012 19:47:58 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <arnd@arndb.de>
Subject: Re: [RFC Patch v1 00/31] Synopsys ARC Linux kernel Port
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com> <20121120134737.GB8111@elf.ucw.cz> <20121120135901.GA9227@elf.ucw.cz>
In-Reply-To: <20121120135901.GA9227@elf.ucw.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2012 07:29 PM, Pavel Machek wrote:
> On Tue 2012-11-20 14:47:37, Pavel Machek wrote:
>> Hi!
>>
>>>     https://raw.github.com/vineetgarc/publish/master/ELCE-2012-ARC-Linux.pdf
>>>
>>> All comments/criticisms are welcome !
>> Huh. arch/arc is very similar to arch/arm. So similar that it took me
>> 10 minutes to figure out. I guess theres no alternate name arc could
>> use?
> Hmm... "Advanced Risc"... :-(.
>
> Ok, plus there's already computing standard called "arc".
>
> https://www.linux-mips.org/wiki/ARC
>
> What about calling the architecture "sarc" or "syarc" ?

I think it would be best use of everybody's time if you could focus on
the technical content of the port rather than the name. It has been like
that for +10 years and I don't intend to make the kernel port name
different from THE arch name itself.




>
> 									Pavel

