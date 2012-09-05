Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab2IEIpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 04:45:00 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:41401 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2IEIo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 04:44:58 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>
Cc: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: Re: [Drbd-dev] FLUSH/FUA documentation & code discrepancy
Date: Wed, 05 Sep 2012 10:44:55 +0200
Message-ID: <3029802.oqG0dEY71l@fat-tyre>
User-Agent: KMail/4.8.4 (Linux/3.2.0-29-generic; KDE/4.8.4; x86_64; ; )
In-Reply-To: <20120904224620.GB9092@dhcp-172-17-108-109.mtv.corp.google.com>
References: <8439412.RChiDciQdh@fat-tyre> <20120904224620.GB9092@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Currently, FLUSH/FUA doesn't enforce any ordering requirement.  File
> systems are responsible for draining all writes which have to happen
> before and not issue further writes which should come after.

Ok. That is a clear statement. So we will do it that way.

The "Currently" in you statement, suggests that there might be something
more mighty in the future. Is that true?

We are looking for a method that allows us to submit some writes, then
an IO-barrier, and then further writes. 

Best,
 Phil
