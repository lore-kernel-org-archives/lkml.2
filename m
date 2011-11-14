Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab1KNR6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:58:41 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36739 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1KNR6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:58:40 -0500
Date: Mon, 14 Nov 2011 09:58:34 -0800
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET block:for-3.2/core] cleanup io_context interface
Message-ID: <20111114175834.GB30922@google.com>
References: <1319932187-7631-1-git-send-email-tj@kernel.org>
 <20111103150816.GD4417@google.com>
 <4EB3AD7B.4050800@kernel.dk>
 <CAOS58YM+=K=qXrfjKtGv3-QqB=H7KcLzsW5b5M2-wLkm7nbOFw@mail.gmail.com>
 <4EB3F6B5.1010606@kernel.dk>
 <20111114174059.GA30922@google.com>
 <4EC15552.4020509@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC15552.4020509@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

On Mon, Nov 14, 2011 at 06:52:18PM +0100, Jens Axboe wrote:
> We agreed to queue these for 3.3, right?

Ah... I'm getting confused about version numbers.  This is 3.2-rc1, so
yes this is for 3.3-rc1.  Just wondering whether/when you are gonna
pull this into -next.  If you agree with the series, I'll be going
ahead and making similar changes to blkcg.

Thank you.

-- 
tejun
