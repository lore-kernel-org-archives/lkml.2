Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab0GXGCZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 02:02:25 -0400
Received: from smtp.nokia.com ([192.100.105.134]:35251 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab0GXGCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 02:02:24 -0400
Subject: Re: [PATCHv4 10/14] writeback: move bdi threads exiting logic to
 the forker thread
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100723162311.GA29633@infradead.org>
References: <1279897554-1526-1-git-send-email-dedekind1@gmail.com>
	 <1279897554-1526-11-git-send-email-dedekind1@gmail.com>
	 <20100723162311.GA29633@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Jul 2010 08:55:06 +0300
Message-ID: <1279950907.4655.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jul 2010 06:02:12.0015 (UTC) FILETIME=[C1FD53F0:01CB2AF5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-23 at 12:23 -0400, Christoph Hellwig wrote:
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Maybe bdi_forker_thread can be cleaned up a bit more by introducing a
> 
> enum {
> 	NO_ACTION,
> 	START_THREAD,
> 	KILL_THREAD,
> } action;
> 
> and then do a switch based on it later?

Just did this. May be it became a bit nicer, not sure. Matter of taste.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

