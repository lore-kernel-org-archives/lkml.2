Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934698Ab2C3UsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:48:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:54151 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072Ab2C3UsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:48:04 -0400
Date: Fri, 30 Mar 2012 16:45:54 -0400 (EDT)
Message-Id: <20120330.164554.2217665316338460995.davem@davemloft.net>
To: rodrigue@qca.qualcomm.com
Cc: xiong@qca.qualcomm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qca-linux-team@qualcomm.com,
        nic-devel@qualcomm.com, kgiori@qca.qualcomm.com, chris.snook@gmail.com,
        mathieu@qca.qualcomm.com, bryanh@quicinc.com, jespera@diku.dk,
        julia@diku.dk
Subject: Re: [PATCH] net: add QCA alx Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAB=NE6WPWmrTZ__JQViqhde-krBsbM5G+ZQgK0pNC+W909u_ew@mail.gmail.com>
References: <20120228.223258.2261979237568571219.davem@davemloft.net>
	<CAB=NE6W-CYjEhbfYOv7XqXFGvdhZxRECqfAmgouaa5_j45gnOQ@mail.gmail.com>
	<CAB=NE6WPWmrTZ__JQViqhde-krBsbM5G+ZQgK0pNC+W909u_ew@mail.gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 30 Mar 2012 13:45:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Fri, 30 Mar 2012 10:10:55 -0700

> On Wed, Mar 21, 2012 at 6:28 PM, Luis R. Rodriguez
> <rodrigue@qca.qualcomm.com> wrote:
>> On Tue, Feb 28, 2012 at 7:32 PM, David Miller <davem@davemloft.net> wrote:
>> Would it be worthwhile to consider alx upstream only for the newer
>> chipsets (regardless of the litmus test, which I do agree with on
>> technical grounds) in consideration for helping pave the way on
>> killing proprietary drivers?
 ...
> David, please us know if you think the above reason is worthy for
> consideration of alx upstream, if at least for the newer chipsets.

Submitting alx that only supports the newer chipsets is fine.
