Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab2IULkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 07:40:05 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:23272 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab2IULkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 07:40:03 -0400
Date: Fri, 21 Sep 2012 14:39:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: maximlevitsky@gmail.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: memstick: add support for legacy memorysticks
Message-ID: <20120921113957.GD13767@mwanda>
References: <20120921113745.GA21483@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921113745.GA21483@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some other Smatch complaints as well.

drivers/memstick/core/ms_block.c:990 msb_verify_block() warn: signedness bug returning '-5'
drivers/memstick/core/ms_block.c:996 msb_verify_block() warn: signedness bug returning '-5'
drivers/memstick/core/ms_block.c:1410 msb_ftl_scan() warn: possible memory leak of 'overwrite_flags'

regards,
dan carpenter
