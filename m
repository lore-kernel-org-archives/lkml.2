Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab2CZVcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 17:32:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56967 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755541Ab2CZVcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 17:32:13 -0400
Message-ID: <4F70E042.4020703@zytor.com>
Date: Mon, 26 Mar 2012 14:31:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Daniel Drake <dsd@laptop.org>, mingo@redhat.com, tglx@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org, dilinger@queued.net,
        pgf@laptop.org
Subject: Re: [PATCH v4] x86, olpc: add debugfs interface for EC commands
References: <20120326180710.8DF9C9D401E@zog.reactivated.net> <20120326142908.c5248aec.akpm@linux-foundation.org>
In-Reply-To: <20120326142908.c5248aec.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 02:29 PM, Andrew Morton wrote:
>>
>> v4: really fix sign-off tags
> 
> s/fix/break/?  "Originally-from" is not a recognised tag.  If this code
> is based upon an earlier version from Paul then Signed-off-by: is
> correct.
> 
> What's going on here?  What are you trying to communicate?

I have been using "Originally-by:" (not Originally-from:) to indicate
content originally written by someone else which has then been
dramatically redone.  It seems to communicate, but probably should be
written into a spec somewhere.

It doesn't make much sense to put that after a Signed-off-by: though
(lines are supposed to be in chronological order.)

	-hpa
