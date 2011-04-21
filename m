Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab1DUCka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:40:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49379 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1DUCk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:40:28 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=xiwGX1Xr2kgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=g3cdqUb-ZZUHcV7zBEUA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 07/11] kbuild/recordmcount: Add RECORDMCOUNT_WARN
 to warn about mcount callers
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
In-Reply-To: <20110421023738.714956282@goodmis.org>
References: <20110421022825.535486725@goodmis.org>
	 <20110421023738.714956282@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 20 Apr 2011 22:40:27 -0400
Message-ID: <1303353627.7181.110.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 22:28 -0400, Steven Rostedt wrote:
> plain text document attachment
> (0007-kbuild-recordmcount-Add-RECORDMCOUNT_WARN-to-warn-ab.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> When mcount is called in a section that ftrace will not modify it into
> a nop, we want to warn about this. But not warn about this always. Now
> if the user builds the kernel with the option RECORDMCOUNT_WARN=1 then
> the build will warn about mcount callers that are ignored and will just
> waste execution time.
> 
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: linux-kbuild@vger.kernel.org
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Michal,

Can I get an Acked-by from you for this patch. Or comments if it doesn't
suit you?

Thanks,

-- Stvee


