Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454Ab0GUOXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 10:23:12 -0400
Received: from mail.tpi.com ([70.99.223.143]:1972 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624Ab0GUOXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 10:23:11 -0400
Message-ID: <4C47029E.8020803@mail.tpi.com>
Date: Wed, 21 Jul 2010 16:22:22 +0200
From: Tim Gardner <tcanonical@tpi.com>
Reply-To: tim.gardner@canonical.com
Organization: Canonical, Ltd
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: Dave Airlie <airlied@redhat.com>, jbarnes@virtuousgeek.org,
        eric@anholt.net, Kees Cook <kees@canonical.com>,
        linux-kernel@vger.kernel.org, Gordon Jin <gordon.jin@intel.com>
Subject: Re: i915 boot regression on Q35 chipset with 2.6.35-rc4
References: <4C46E98A.3010206@mail.tpi.com> <8u3s94$g0j0tc@orsmga002.jf.intel.com>
In-Reply-To: <8u3s94$g0j0tc@orsmga002.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2010 03:37 PM, Chris Wilson wrote:
> On Wed, 21 Jul 2010 14:35:22 +0200, Tim Gardner<tcanonical@tpi.com>  wrote:
>> What's up with this patch? I haven't received any comment, nor has it
>> appeared in your git repository.
>
> Dave hasn't taken it because it is a regression fix for i915 and the
> current procedure is for those to go through Eric's tree. Eric has been
> busy working on a new compiler for GLSL the last few weeks and has been
> applying patches in batches.
>
> The patch I am happy to ack, but since I introduced the regression
> [https://bugzilla.kernel.org/show_bug.cgi?id=16294], I'd rather have
> someone more familiar with the intricacies of G33/G35/Q35 review it.
>
> For what is worth:
> Acked-by: Chris Wilson<chris@chris-wilson.co.uk>
>

The events that reminded me to look up the status of this patch were the 
i915 regression fixes that recently appeared in 
git-commits-head@vger.kernel.org from Dave's tree (which appears to be 
contrary to the current procedure mentioned above).

rtg
-- 
Tim Gardner tim.gardner@canonical.com
