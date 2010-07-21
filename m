Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0GURMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:12:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60576 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986Ab0GURMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:12:13 -0400
Message-ID: <4C472A5C.50004@zytor.com>
Date: Wed, 21 Jul 2010 10:11:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/10] x86, xsave: some code cleanups and reworks
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com> <20100720192717.GC6227@lenovo> <20100720194606.GO26154@erda.amd.com> <20100720200729.GD6227@lenovo> <20100720201740.GE6227@lenovo> <4C472123.1090900@zytor.com> <20100721165211.GD8009@lenovo> <20100721170124.GE8009@lenovo>
In-Reply-To: <20100721170124.GE8009@lenovo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2010 10:01 AM, Cyrill Gorcunov wrote:
> 
> Peter, also I think such tuning must be done at merge window time only,
> just to not break other's patch queues.
> 

Realistically it should be done right after the merge window for the
*next* merge window.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

