Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902Ab1LPO6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:58:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44715 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759627Ab1LPO5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:57:51 -0500
Message-ID: <4EEB5C6A.6010103@lwfinger.net>
Date: Fri, 16 Dec 2011 08:57:46 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Nick Bowler <nbowler@elliptictech.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        Arend van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: unexpected taint message
References: <4EEB0EFC.5000302@broadcom.com> <1324038636.3429.1.camel@jlt3.sipsolutions.net> <4EEB4D61.80602@lwfinger.net> <1324043939.3429.2.camel@jlt3.sipsolutions.net> <20111216144804.GA11693@elliptictech.com>
In-Reply-To: <20111216144804.GA11693@elliptictech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 08:48 AM, Nick Bowler wrote:
> On 2011-12-16 14:58 +0100, Johannes Berg wrote:
>> Hmm. I wish OOT didn't disable lockdep, we do a lot of development with
>> modules OOT because the turnaround is faster/easier (for not so
>> experienced developers). Worst case we can patch it out of the base
>> kernel I guess...
>
> Indeed, but the good news is that we should finally be able to put this
> issue behind us soon(ish).
>
>    https://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commit;h=9ec84acee1e221d99dc33237bff5e82839d10cc0

Is that patch queued for 3.3?

Larry

