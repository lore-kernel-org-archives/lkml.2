Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab0KBQw7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 12:52:59 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:59437 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751655Ab0KBQwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 12:52:55 -0400
Message-ID: <4CD041AE.80009@euromail.se>
Date: Tue, 02 Nov 2010 17:51:58 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: gimli <gimli@dark-green.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] MacBookAir3,1(3,2) touchpad ( bcm5974 ) support
References: <4f8c3332b3e4cdec23a7caafc534a395@mognix.dark-green.com>
In-Reply-To: <4f8c3332b3e4cdec23a7caafc534a395@mognix.dark-green.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PDK5W-0000a1-9V.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PDK5W-0000a1-9V 1e5d2a0abbd948b25592f2d0d3f47687
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2010 08:18 AM, gimli wrote:

> This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the
> bcm5974 driver.
> 
> Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>


Thanks for your patches. Do the usb message packet lengths of these new device
ids differ in any respect from the old ones? What is the difference between the
two sets of ids? Physical size? Are the devices really exactly the same?

Any additional information you can provide to shed light on these questions
would be greatly appreciated. My concern is that there might be more things that
need to be changed for these devices.

Thanks,
Henrik

