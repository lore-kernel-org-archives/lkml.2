Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0DOXkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:40:17 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:35531 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754326Ab0DOXkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:40:15 -0400
X-Greylist: delayed 1112 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2010 19:40:14 EDT
Message-ID: <4BC79F75.2090704@acm.org>
Date: Thu, 15 Apr 2010 17:21:25 -0600
From: Zan Lynx <zlynx@acm.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Taras Glek <tglek@mozilla.com>, linux-kernel@vger.kernel.org
Subject: Re: Downsides to madvise/fadvise(willneed) for application startup
References: <4BBA6776.5060804@mozilla.com> <20100415155309.2649a29b.akpm@linux-foundation.org>
In-Reply-To: <20100415155309.2649a29b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20100415/1O2YNC-0000yn-Jr-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/15/10 4:53 PM, Andrew Morton wrote:

> This just isn't an interesting case.  World-wide, the number of people
> who compile their own web browser and execute it from the file which ld
> produced is, umm, seven.

Gentoo users? Linux From Scratch?

There are many more than 7 of us. Unless you are talking about the build 
environments always running some tool after ld which I am not aware of.


-- 
Zan Lynx
zlynx@acm.org

"Knowledge is Power.  Power Corrupts.  Study Hard.  Be Evil."
