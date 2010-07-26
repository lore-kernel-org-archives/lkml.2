Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab0GZS06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 14:26:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50499 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab0GZS04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 14:26:56 -0400
Message-ID: <4C4DD35C.8060708@zytor.com>
Date: Mon, 26 Jul 2010 11:26:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] x86, xsave: disable xsave in i387 emulation mode
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com> <1279731838-1522-7-git-send-email-robert.richter@amd.com> <1279736162.2812.3.camel@sbs-t61.sc.intel.com> <20100722123603.GU26154@erda.amd.com>
In-Reply-To: <20100722123603.GU26154@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 05:36 AM, Robert Richter wrote:
> On 21.07.10 14:16:02, Suresh Siddha wrote:
> 
>> I think it is cleaner to clear these cpu capabilities in the function
>> which handles no387 boot parameter.
> 
> This does not cover all (of course weird but potentially existing)
> cases. Disabling xsave in the no387 setup would only work if an fpu
> exists.

If the fpu doesn't exist, then xsave can't exist, either.

	-hpa
