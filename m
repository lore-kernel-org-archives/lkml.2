Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab2BTA7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:59:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57633 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab2BTA7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:59:30 -0500
Message-ID: <4F419AE0.7060104@zytor.com>
Date: Sun, 19 Feb 2012 16:59:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org, hjl.tools@gmail.com,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH 08/30] compat: Use COMPAT_USE_64BIT_TIME in the lp driver
References: <1329696488-16970-1-git-send-email-hpa@zytor.com> <1329696488-16970-9-git-send-email-hpa@zytor.com> <CA+55aFwiV3N-9-pB6ofN-5GBS0mnPTBGAdPH1M70wK8qr-=PQg@mail.gmail.com>
In-Reply-To: <CA+55aFwiV3N-9-pB6ofN-5GBS0mnPTBGAdPH1M70wK8qr-=PQg@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2012 04:56 PM, Linus Torvalds wrote:
> On Sun, Feb 19, 2012 at 4:07 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> From: "H. J. Lu" <hjl.tools@gmail.com>
>>
>> Enable the lp driver to be used with a compat ABI with 64-bit time.
> 
> Ugh. Is this really the only case?
> 

No, it's not the only case, and a helper function is a great idea.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

