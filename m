Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab2JIMec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:34:32 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:37971 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab2JIMe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:34:27 -0400
Date: Tue, 9 Oct 2012 15:33:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Roberto Corrado <i@secure.corradoroberto.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING: at block/genhd.c:1570 disk_clear_events+0xbf/0xd0()
Message-ID: <20121009123329.GH28937@mwanda>
References: <98D4C13641D5474D9995328F2593DF7E@unknown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98D4C13641D5474D9995328F2593DF7E@unknown>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixed in:
commit fdd514e16bb2531c0c61ae8a1f87740ce217f630
Author: Tejun Heo <tj@kernel.org>
Date:   Thu Jun 9 20:43:59 2011 +0200

    block: make disk_block_events() properly wait for work cancellation

regards,
dan carpenter

