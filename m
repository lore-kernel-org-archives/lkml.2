Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1KURen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:34:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47747 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab1KURem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:34:42 -0500
Message-ID: <4ECA8B66.2090001@zytor.com>
Date: Mon, 21 Nov 2011 09:33:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        kbuild@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H.J. Lu" <hjl.tools@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 2/8] kbuild: Add support for an "archheaders" target
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com> <1321569446-20433-3-git-send-email-hpa@linux.intel.com> <4ECA8991.20302@suse.cz>
In-Reply-To: <4ECA8991.20302@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 09:25 AM, Michal Marek wrote:
>>  {
>>  	if [ -f ${srctree}/arch/$2/include/asm/Kbuild ]; then
>> +		make ARCH=$2 KBUILD_HEADERS=$1 archheaders
>>  		make ARCH=$2 KBUILD_HEADERS=$1 headers_$1
> 
> I don't think we need the explicit make archheaders call here, it's
> handled by the __headers dependency above.
> 

OK, let me test that out.  I might have missed that combination of the
many, many I tried...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

