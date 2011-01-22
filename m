Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab1AVBSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:18:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41228
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564Ab1AVBSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:18:52 -0500
Date: Fri, 21 Jan 2011 17:19:26 -0800 (PST)
Message-Id: <20110121.171926.266113295.davem@davemloft.net>
To: jaxboe@fusionio.com
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 02/10] ide-cd: convert to blk_delay_queue() for a short
 pause
From: David Miller <davem@davemloft.net>
In-Reply-To: <1295659049-2688-3-git-send-email-jaxboe@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	<1295659049-2688-3-git-send-email-jaxboe@fusionio.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jaxboe@fusionio.com>
Date: Sat, 22 Jan 2011 01:17:21 +0000

> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

Acked-by: David S. Miller <davem@davemloft.net>
