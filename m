Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab2LCR1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:27:51 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59466 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab2LCR1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:27:49 -0500
Message-ID: <50BCE112.3050203@wwwdotorg.org>
Date: Mon, 03 Dec 2012 10:27:46 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V7 3/7] arm64: use new common dtc rule
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org> <1354058956-7199-3-git-send-email-swarren@wwwdotorg.org> <20121129143041.GC30437@arm.com>
In-Reply-To: <20121129143041.GC30437@arm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2012 07:30 AM, Catalin Marinas wrote:
> On Tue, Nov 27, 2012 at 11:29:12PM +0000, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> The current rules have the .dtb files build in a different directory
>> from the .dts files. This patch changes arm64 to use the generic dtb
>> rule which builds .dtb files in the same directory as the source .dts.
>>
>> This requires moving parts of arch/arm64/boot/Makefile into newly created
>> arch/arm64/boot/dts/Makefile, and updating arch/arm64/Makefile to call the
>> new Makefile.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> I had a bit more clean-up in a local patch (see attached). Depending on
> the timing, you can just fold it into your patch (basically removing the
> MACHINE argument, adding KBUILD_DTBS and dtbs target help). It's been
> derived from your arch/arm patch anyway ;).

Thanks. Just to follow up on this, Rob has applied the series (minus
Xtensa) to a local tree, I believe intending to take it for 3.8(?), and
has included a modified version of this patch there (i.e. rebased onto
my series and hence slightly adjusted for it).
