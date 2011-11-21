Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1KUUCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:02:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab1KUUCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:02:53 -0500
Message-ID: <4ECAAE9F.1050107@suse.cz>
Date: Mon, 21 Nov 2011 21:03:43 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H.J. Lu" <hjl.tools@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 2/8] kbuild: Add support for an "archheaders" target
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com> <1321569446-20433-3-git-send-email-hpa@linux.intel.com> <4ECA8991.20302@suse.cz> <4ECA8B66.2090001@zytor.com>
In-Reply-To: <4ECA8B66.2090001@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 21.11.2011 18:33, H. Peter Anvin napsal(a):
> On 11/21/2011 09:25 AM, Michal Marek wrote:
>>>  {
>>>  	if [ -f ${srctree}/arch/$2/include/asm/Kbuild ]; then
>>> +		make ARCH=$2 KBUILD_HEADERS=$1 archheaders
>>>  		make ARCH=$2 KBUILD_HEADERS=$1 headers_$1
>>
>> I don't think we need the explicit make archheaders call here, it's
>> handled by the __headers dependency above.
>>
> 
> OK, let me test that out.  I might have missed that combination of the
> many, many I tried...

I tried make headers_install_all on a ppc64 box with that line removed
and it worked.

Michal
