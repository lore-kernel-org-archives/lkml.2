Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161152Ab2CPNh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 09:37:29 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:58356 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031249Ab2CPNhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 09:37:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120315135841.affff2d75681451d9ddd1a58@canb.auug.org.au>
References: <alpine.LSU.2.00.1203131454500.1335@eggly.anvils>
	<1331770181-800-1-git-send-email-daniel.lezcano@linaro.org>
	<20120315111415.cd119171ac86967aebe85545@canb.auug.org.au>
	<alpine.LSU.2.00.1203141720360.2003@eggly.anvils>
	<20120315135841.affff2d75681451d9ddd1a58@canb.auug.org.au>
Date: Fri, 16 Mar 2012 15:37:07 +0200
X-Google-Sender-Auth: fCuAqv41Klp78dShgOBmIJXWtho
Message-ID: <CAHLCerOeSHvFXb9ZnBDc1RjETbMLoMNYWqtrM=ipp_iX9XZ1cQ@mail.gmail.com>
Subject: Re: [PATCH] cpuidle : fix random hangs with intel_idle
From: Amit Kucheria <amit.kucheria@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Hugh Dickins <hughd@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, akpm@linux-foundation.org,
        rob.lee@linaro.org, j-pihet@ti.com, khilman@ti.com,
        deepthi@linux.vnet.ibm.com, dan.carpenter@oracle.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 4:58 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Hugh,
>
> On Wed, 14 Mar 2012 17:23:26 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
>>
>> On Thu, 15 Mar 2012, Stephen Rothwell wrote:
>> >
>> > So this needs to go into Rob's tree.  Maybe after Hugh verifies that it
>> > fixes his problem.
>>
>> Yes, Daniel got me to try it offline before he posted it.
>>
>> Tested-by: Hugh Dickins <hughd@google.com>
>
> Excellent.
>
>> Personally, I'd recommend including it even before it gets into Rob's
>> tree (where it may well be improved upon first): it does a lot to
>> improve the usability of linux-next.
>
> OK, so I will add this patch to today's tree (on the assumption that it,
> or something better, will be added to Rob's tree soon).

Stephen,

A slight glitch: Rob is away until Tuesday. Should Daniel create a new
branch to carry this?

/Amit
