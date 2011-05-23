Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab1EWR5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:57:49 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51084 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512Ab1EWR5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:57:48 -0400
Message-ID: <4DDAA01A.2000202@kernel.dk>
Date: Mon, 23 May 2011 19:57:46 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splice: add wakeup_pipe_readers()
References: <1306159114-3192-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1306159114-3192-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-23 15:58, Namhyung Kim wrote:
> Add and use wakeup_pipe_readers() to consolidate duplicated codes.

Looks fine, thanks. Applied.

-- 
Jens Axboe

