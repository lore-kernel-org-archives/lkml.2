Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab1HMTEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 15:04:23 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64987 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab1HMTEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 15:04:22 -0400
MIME-Version: 1.0
In-Reply-To: <20110813185453.GA16933@infradead.org>
References: <20110813153237.GD4254@htj.dyndns.org>
	<20110813185453.GA16933@infradead.org>
Date: Sat, 13 Aug 2011 21:04:21 +0200
X-Google-Sender-Auth: szMvx8QkCremKhVvBZWUwMJ6iQE
Message-ID: <CAOS58YPr1zzN6UPxMs9UaViej4cLDEU9awd3y=yFnZBSqCu4=Q@mail.gmail.com>
Subject: Re: [PATCH] block: add GENHD_FL_UNPARTITIONABLE
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Aug 13, 2011 at 8:54 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Aug 13, 2011 at 05:32:37PM +0200, Tejun Heo wrote:
>> There are cases where suppressing partition scan is useful - e.g. for
>> lo devices
>
> Err, partitioning loop devices is extremly useful.

Oh yeah it is. It's to allow toggling it dynamically via losetup
(currently, it's decided by module param). It's part of making lo more
dynamic.

Thanks.

-- 
tejun
