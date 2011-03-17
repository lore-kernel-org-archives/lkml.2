Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1CQKIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:08:23 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55921 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab1CQKIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:08:21 -0400
Message-ID: <4D81DD93.6080909@fusionio.com>
Date: Thu, 17 Mar 2011 11:08:19 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "ctalbott@google.com" <ctalbott@google.com>,
        "mrubin@google.com" <mrubin@google.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "guijianfeng@cn.fujitsu.com" <guijianfeng@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] Don't update group weights when on service tree.
References: <1297458543-14779-1-git-send-email-teravest@google.com> <20110214165050.GD13097@redhat.com> <AANLkTi=x=3KiXiWdMpeXHLaCGKmN+7+ff7sdC+srmJzM@mail.gmail.com>
In-Reply-To: <AANLkTi=x=3KiXiWdMpeXHLaCGKmN+7+ff7sdC+srmJzM@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-16 21:28, Justin TerAvest wrote:
> Jens,
> 
> Could you please take a look and apply if this looks good to you?

It looks fine, however it doesn't apply to for-2.6.39/core:

patching file block/cfq-iosched.c
Hunk #1 succeeded at 178 (offset -1 lines).
Hunk #2 succeeded at 855 (offset -10 lines).
Hunk #3 succeeded at 896 (offset -10 lines).
Hunk #4 succeeded at 920 (offset -10 lines).
Hunk #5 succeeded at 974 (offset -4 lines).
Hunk #6 succeeded at 1009 (offset -3 lines).
Hunk #7 FAILED at 1223.
Hunk #8 FAILED at 1233.
Hunk #9 succeeded at 1284 (offset -29 lines).
Hunk #10 succeeded at 1397 with fuzz 1 (offset -27 lines).
2 out of 10 hunks FAILED -- saving rejects to file
block/cfq-iosched.c.rej

Can you send me an updated variant, and I'll get it applied.

-- 
Jens Axboe

