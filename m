Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843Ab0JZMAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 08:00:18 -0400
Received: from emroute4.ornl.gov ([160.91.86.27]:41152 "EHLO emroute4.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757505Ab0JZMAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 08:00:15 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2010 08:00:15 EDT
Date: Tue, 26 Oct 2010 07:52:12 -0400
From: David Dillow <dave@thedillows.org>
Subject: Re: [PATCH 7/14] drivers/net/typhoon.c: delete double assignment
In-reply-to: <1288088743-3725-8-git-send-email-julia@diku.dk>
To: Julia Lawall <julia@diku.dk>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-id: <1288093932.14943.1.camel@lap75545.ornl.gov>
MIME-version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13)
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
 <1288088743-3725-8-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 12:25 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Delete successive assignments to the same location.  The current definition
> does not initialize the respRing structure, which has the same type as the
> cmdRing structure, so initialize that one instead.

> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: David Dillow <dave@thedillows.org>

> ---
> This changes the semantics and has not been tested.

tp->respRing.lastWrite is only an artifact of using a common struct for
the rings and is not otherwise used, so no change to semantics.
