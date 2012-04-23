Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab2DWUTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:19:43 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2233 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239Ab2DWUTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:19:41 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
Message-ID: <4F95B951.6020700@broadcom.com>
Date: Mon, 23 Apr 2012 13:19:29 -0700
From: "Jiandong Zheng" <jdzheng@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327
 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Christian Dietrich" <dietrich@cs.fau.de>
cc: "Scott Branden" <sbranden@broadcom.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: Possible integer overflow in mach-bcmring with FPGA11107
References: <86r4veipp8.fsf@gandalf.zerties.org>
In-Reply-To: <86r4veipp8.fsf@gandalf.zerties.org>
X-WSS-ID: 638B66DB3E021989232-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/2012 5:43 AM, Christian Dietrich wrote:
>
> This seems totally innocent, but when doing the caluculation for
> rate_hz by hand (or python) the result is slighly bigger than
> 2^32-1. Therfore an integer overflow should occur and the rate_hz rate
> will be far too low. It may be that there is a sanity check in
> hardware, but i don't know the used hardware at all.
>
Hi Christian,

Yes. This is a problem. I will cleanup fpga11107 code including this soon.

Thanks,
JD

