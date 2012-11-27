Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946Ab2K0KjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 05:39:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab2K0KjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 05:39:17 -0500
Message-ID: <50B4984E.4060607@suse.cz>
Date: Tue, 27 Nov 2012 11:39:10 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Yacine Belkadi <yacine.belkadi.1@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Daniel Santos <daniel.santos@pobox.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [PATCHv2 2/2] scripts/kernel-doc: check that non-void fcts describe
 their return value
References: <1353964883-3121-1-git-send-email-yacine.belkadi.1@gmail.com> <1353964947-3152-1-git-send-email-yacine.belkadi.1@gmail.com> <50B41AC7.8030904@infradead.org>
In-Reply-To: <50B41AC7.8030904@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.11.2012 02:43, Randy Dunlap wrote:
> On 11/26/2012 01:22 PM, Yacine Belkadi wrote:
> 
>> If a function has a return value, but its kernel-doc comment doesn't contain a
>> "Return" section, then emit the following warning:
>>
>>    Warning(file.h:129): No description found for return value of 'fct'
>>
>> Note: This check emits a lot of warnings at the moment, because many functions
>> don't have a 'Return' doc section. So until the number of warnings goes
>> sufficiently down, the check is only performed in verbose mode.
>>
>> Signed-off-by: Yacine Belkadi <yacine.belkadi.1@gmail.com>
> 
> 
> Both patches:
> Acked-by: Randy Dunlap <rdunlap@infradead.org>
> 
> Michal, please merge patches 1 and 2.

Thanks for the review and for adding me to CC. Yacine, could you please
resend the patches? I got unsubscribed from lkml yesterday, because my
@suse mail was bouncing :(.

Thanks,
Michal
