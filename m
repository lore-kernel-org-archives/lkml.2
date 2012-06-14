Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab2FNVEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 17:04:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab2FNVEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 17:04:43 -0400
Message-ID: <4FDA519F.4080204@redhat.com>
Date: Thu, 14 Jun 2012 17:03:27 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Borislav Petkov <bp@amd64.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        sjhill@mips.com, ralf@linux-mips.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: bugs in page colouring code
References: <20120613152936.363396d5@cuia.bos.redhat.com> <20120614103627.GA25940@aftab.osrc.amd.com> <4FD9DFCE.1070609@redhat.com> <4FDA5087.7090606@linux.intel.com>
In-Reply-To: <4FDA5087.7090606@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 04:58 PM, H. Peter Anvin wrote:
> On 06/14/2012 05:57 AM, Rik van Riel wrote:
>>
>> However, I expect that on x86 many applications expect
>> MAP_FIXED to just work, and enforcing that would be
>> more trouble than it's worth.
>>
>
> MAP_FIXED, is well, fixed.  It means that performance be screwed, if we
> can fulfill the request we MUST do so.

My codebase now has a separate arch_align_addr function
for x86, which is surprisingly similar to the generic
one :)
